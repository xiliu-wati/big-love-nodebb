# Technical Design for the Social Posting App

## Overview
This design specifies:
- **Client:** Flutter mobile app (iOS & Android)
- **Backend:** Python (FastAPI) REST API
- **Database:** PostgreSQL (managed)
- **Media:** Cloud object storage (S3/GCS) + CDN
- **Push:** Firebase Cloud Messaging (FCM)
- **Auth:** Custom email/password with JWT
- **Region:** Cloud deployment close to Hong Kong

Supports up to **1M users** and **~10M posts**.

---

## 1. Architecture Overview
**Components**
- Flutter app: UI & user interactions
- FastAPI backend: business logic, API, auth
- PostgreSQL: relational data storage
- Cloud storage + CDN: image/video hosting
- FCM: push notifications
- Load balancer + autoscaling app containers

**Flow**
1. Client sends HTTPS requests to API.
2. API validates/authenticates, processes, interacts with DB.
3. Media is uploaded to object storage via presigned URL.
4. CDN delivers media to clients.
5. FCM pushes notifications for events.

---

## 2. Flutter Client
**State Management**
- Provider or Riverpod

**Screens**
- Auth (Sign Up, Login)
- Unified feed
- Post creation (text, images, videos)
- Post detail (comments, likes)
- Profile & settings
- Notifications (optional in MVP)

**Networking**
- `dio` or `http` package
- JSON models mapping to API
- JWT stored with `flutter_secure_storage`

**Push**
- `firebase_messaging` integration
- Register token with backend
- Handle background/foreground events

---

## 3. Backend Framework Options

### Option A: Custom FastAPI Backend
**Structure**
- app/
  - main.py
  - config.py
  - db.py (SQLAlchemy + Alembic)
  - models/ (ORM models)
  - schemas/ (Pydantic)
  - routers/ (auth, posts, comments, likes, moderation, push, admin, users)
  - services/ (business logic, role_management, points_system)
  - utils/ (helpers, role_checker, points_calculator)
  - middleware/ (role_verification, rate_limiting)

### Option B: NodeBB Framework
**Technology Stack**: Node.js + Redis/MongoDB/PostgreSQL
**Advantages**:
- Real-time interactions via WebSockets
- Extensive plugin ecosystem (gamification, social logins)
- Built-in user roles and permissions
- Active community and support
- Mobile-responsive out of the box
- RESTful API for mobile app integration

**Considerations**:
- Requires Node.js hosting environment
- May need custom plugins for specific role hierarchy
- Learning curve for Python-focused teams

### Option C: Misago Framework  
**Technology Stack**: Python + Django + PostgreSQL
**Advantages**:
- Built on familiar Django framework
- Comprehensive RESTful API
- Modern responsive design
- User roles and permissions system
- Python ecosystem compatibility
- Modular and extensible architecture

**Considerations**:
- Smaller community than NodeBB
- May require more customization for complex role hierarchy
- Performance considerations for very large threads

### Recommended Approach: NodeBB
Given the requirements for user roles, subscription management, and mobile app integration, **NodeBB** is recommended because:
- Built-in user roles and groups system (no custom development needed)
- Real-time features enhance user engagement
- Strong API support for Flutter mobile app
- Native user reputation and privilege system
- Proven scalability for large communities

**NodeBB API Endpoints** (Available out-of-the-box)
- `POST /api/v3/users` (register)
- `POST /api/v3/utilities/login` (login)
- `GET /api/v3/users/{uid}` (user profile)
- `PUT /api/v3/users/{uid}` (update profile)
- `GET /api/v3/topics` (posts/topics)
- `POST /api/v3/topics` (create topic)
- `GET /api/v3/topics/{tid}` (topic details)
- `POST /api/v3/topics/{tid}` (reply to topic)
- `PUT /api/v3/posts/{pid}/vote` (like/vote)
- `GET /api/v3/users/{uid}/reputation` (user points/reputation)
- `GET /api/v3/notifications` (notifications)
- `POST /api/v3/flags` (report content)
- `GET /api/v3/admin/users` (admin user management)
- `PUT /api/v3/admin/users/{uid}` (admin user actions)

**Custom Extensions Needed**:
- Subscription management for MVP users
- Payment integration endpoints
- Enhanced mobile API responses

**Security**
- JWT Bearer auth with role claims
- bcrypt password hashing
- HTTPS
- Role-based access control (RBAC)
- Rate limiting based on user level
- Input validation and sanitization

---

## 4. Database Design

### NodeBB Core Schema (Built-in)
**Redis/MongoDB/PostgreSQL Collections/Tables**:
- **users**: uid, username, email, password, reputation, joindate, lastonline
- **topics**: tid, uid, cid, title, slug, timestamp, postcount, viewcount
- **posts**: pid, tid, uid, content, timestamp, votes, edited
- **categories**: cid, name, description, parentCid, order
- **groups**: name, userTitle, description, memberCount, system
- **notifications**: nid, uid, type, bodyShort, bodyLong, pid, tid

### Custom Extensions Required
**Additional Collections/Tables for Enhanced Features**:
- **subscriptions**: uid, plan_type, start_date, end_date, status, payment_id, stripe_customer_id

### Data Storage Options
- **Redis**: Fast, in-memory (recommended for high-traffic)
- **MongoDB**: Document-based, flexible schema
- **PostgreSQL**: Relational, ACID compliance (recommended for complex queries)

**Indexes**
- uid on posts/topics for user content lookup
- timestamp on posts for feed ordering
- subscription_status on subscriptions for premium feature access

---

## 5. Media Storage
- Use S3 or GCS for file storage
- Deliver via CDN (CloudFront or Cloudflare)
- Backend issues presigned URLs for client upload
- Store only file URLs in DB

---

## 6. Push Notifications (FCM)
**Triggers**
- New comment on your post
- New like (optional or batched)
- Admin/moderation actions
- Subscription reminders
- Exclusive content alerts (MVP users)

**Flow**
- Client gets FCM token
- Sends token to backend
- NodeBB stores token in notification system
- On events, backend sends push via Firebase Admin SDK
- Group-based notification filtering

---

## 7. Authentication & Authorization
- NodeBB native email/password authentication
- bcrypt for password hashing (built-in)
- Session-based auth or JWT tokens for API access
- Built-in user groups and permissions system
- Group-based feature access (Regular, MVP, Special, Moderator, Admin)
- Subscription status integration with user groups

---

## 8. User Management & Subscriptions
**NodeBB Native User System**
- Built-in user groups and privileges (Regular, Special, Moderator, Admin)
- Native reputation system based on user activity
- Group-based permissions and access control
- Admin tools for user and group management

**Subscription Management**
- MVP user subscription tracking via custom plugin
- Payment integration (Stripe/PayPal) hooks
- Subscription status validation middleware
- Grace period handling for expired subscriptions
- Automatic group assignment based on subscription status

---

## 9. Cloud Deployment

### NodeBB Deployment Options
- **Provider:** AWS/GCP/DigitalOcean
- **Backend:** 
  - Dockerized NodeBB application
  - ECS/Fargate, Cloud Run, or Kubernetes
  - Load balancer for high availability
- **Database Options:**
  - **Redis Cluster** (recommended for performance)
  - **MongoDB Atlas** (managed, scalable)
  - **PostgreSQL** (managed, ACID compliance)
- **File Storage:** S3/GCS for uploads and media
- **CDN:** CloudFront/Cloudflare for static assets
- **Monitoring:** 
  - NodeBB built-in analytics
  - CloudWatch/Stackdriver for infrastructure
  - Custom dashboards for user progression metrics
- **Secrets:** Environment variables, Secret Manager/SSM

### Scaling Considerations
- **Horizontal Scaling:** Multiple NodeBB instances behind load balancer
- **Database Scaling:** Redis clustering or MongoDB sharding
- **Session Storage:** Redis for session management across instances
- **Real-time Features:** Socket.io clustering for WebSocket connections

---

## 10. Future Enhancements
- Multiple communities
- Direct messaging
- Events
- Social login
- Ads
- AI-assisted moderation
- Community-specific role systems
- Subscription tier expansion
- Analytics dashboard for user activity and progression

---

## 11. Summary

### Framework Decision: NodeBB
This architecture leverages **NodeBB** as the backend framework, providing:
- **Rapid Development**: 80% of core features built-in (auth, posts, comments, moderation)
- **Scalability**: Proven to handle millions of users with proper deployment
- **Real-time Features**: WebSocket support for live interactions
- **Extensibility**: Plugin system for custom role hierarchy and user progression
- **Mobile Integration**: RESTful API ready for Flutter app consumption
- **Security**: Built-in RBAC, input sanitization, and security best practices
- **Community Support**: Active ecosystem with extensive documentation

### Key Benefits Over Custom Development
- **Time to Market**: 3-6 months faster than building from scratch
- **Reduced Risk**: Battle-tested codebase with proven scalability
- **Lower Maintenance**: Framework updates handle security patches and improvements
- **Plugin Ecosystem**: Leverage existing solutions for common features
- **Focus on Differentiation**: Spend development time on unique features (role hierarchy, user progression)

### Custom Development Required
- Subscription management plugin
- Payment integration (Stripe/PayPal)
- Enhanced mobile API endpoints
- Automatic group assignment based on subscription status