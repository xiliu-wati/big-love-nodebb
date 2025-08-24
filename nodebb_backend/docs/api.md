# NodeBB API Documentation

## Base URL
- Development: `http://localhost:4567/api/v3`
- Production: `https://your-domain.com/api/v3`

## Authentication

### Login
```http
POST /api/v3/utilities/login
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "password123"
}
```

### Register
```http
POST /api/v3/users
Content-Type: application/json

{
  "username": "newuser",
  "email": "user@example.com", 
  "password": "password123"
}
```

## Posts/Topics

### Get Topics Feed
```http
GET /api/v3/topics?page=1&limit=20
```

### Create Topic
```http
POST /api/v3/topics
Content-Type: application/json
Authorization: Bearer <token>

{
  "title": "My Post Title",
  "content": "Post content here",
  "cid": 1
}
```

### Get Topic Details
```http
GET /api/v3/topics/{tid}
```

### Reply to Topic
```http
POST /api/v3/topics/{tid}
Content-Type: application/json
Authorization: Bearer <token>

{
  "content": "Reply content"
}
```

## Users

### Get User Profile
```http
GET /api/v3/users/{uid}
```

### Update Profile
```http
PUT /api/v3/users/{uid}
Content-Type: application/json
Authorization: Bearer <token>

{
  "fullname": "Full Name",
  "aboutme": "About me text"
}
```

## Moderation

### Report Content
```http
POST /api/v3/flags
Content-Type: application/json
Authorization: Bearer <token>

{
  "type": "topic",
  "id": 123,
  "reason": "Spam"
}
```

## Response Format

### Success Response
```json
{
  "status": "ok",
  "response": {
    // Data here
  }
}
```

### Error Response
```json
{
  "status": "error",
  "message": "Error description"
}
```
