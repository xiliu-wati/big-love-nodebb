const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Demo Data
const users = [
  {
    id: 1,
    username: 'alice_admin',
    email: 'alice@biglove.com',
    displayName: 'Alice Johnson',
    bio: 'Forum Administrator and Community Manager',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    role: 'admin',
    status: 'online',
    joinedAt: '2023-01-15T10:30:00Z',
    stats: {
      totalPosts: 234,
      totalReactions: 1500,
      forumsJoined: 5,
      reputation: 2500
    }
  },
  {
    id: 2,
    username: 'bob_vip',
    email: 'bob@example.com',
    displayName: 'Bob Smith',
    bio: 'VIP member and tech enthusiast',
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
    role: 'moderator',
    status: 'online',
    joinedAt: '2023-03-20T14:15:00Z',
    stats: {
      totalPosts: 156,
      totalReactions: 890,
      forumsJoined: 4,
      reputation: 1200
    }
  },
  {
    id: 3,
    username: 'charlie_dev',
    email: 'charlie@example.com',
    displayName: 'Charlie Wilson',
    bio: 'Flutter developer and open source contributor',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    role: 'user',
    status: 'away',
    joinedAt: '2023-05-10T09:45:00Z',
    stats: {
      totalPosts: 89,
      totalReactions: 445,
      forumsJoined: 3,
      reputation: 650
    }
  },
  {
    id: 4,
    username: 'diana_designer',
    email: 'diana@example.com',
    displayName: 'Diana Martinez',
    bio: 'UI/UX Designer passionate about beautiful interfaces',
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
    role: 'user',
    status: 'online',
    joinedAt: '2023-07-02T16:20:00Z',
    stats: {
      totalPosts: 67,
      totalReactions: 320,
      forumsJoined: 2,
      reputation: 450
    }
  },
  {
    id: 5,
    username: 'erik_newbie',
    email: 'erik@example.com',
    displayName: 'Erik Thompson',
    bio: 'New to the community, eager to learn!',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    role: 'user',
    status: 'offline',
    joinedAt: '2023-11-15T12:00:00Z',
    stats: {
      totalPosts: 12,
      totalReactions: 45,
      forumsJoined: 2,
      reputation: 85
    }
  }
];

const forums = [
  {
    id: 1,
    name: 'General Discussion',
    description: 'Open discussions about anything and everything',
    icon: '📢',
    category: 'general',
    memberCount: 1250,
    postCount: 3420,
    isPrivate: false,
    tags: ['general', 'discussion', 'community']
  },
  {
    id: 2,
    name: 'Tech Support',
    description: 'Get help with technical issues and troubleshooting',
    icon: '🔧',
    category: 'support',
    memberCount: 890,
    postCount: 2156,
    isPrivate: false,
    tags: ['support', 'help', 'technical']
  },
  {
    id: 3,
    name: 'VIP Lounge',
    description: 'Exclusive discussions for VIP members only',
    icon: '👑',
    category: 'vip',
    memberCount: 45,
    postCount: 234,
    isPrivate: true,
    tags: ['vip', 'exclusive', 'premium']
  },
  {
    id: 4,
    name: 'Admin Area',
    description: 'Administrative announcements and discussions',
    icon: '⚡',
    category: 'admin',
    memberCount: 12,
    postCount: 67,
    isPrivate: true,
    tags: ['admin', 'announcements', 'official']
  },
  {
    id: 5,
    name: 'Feature Requests',
    description: 'Suggest new features and improvements',
    icon: '💡',
    category: 'feedback',
    memberCount: 567,
    postCount: 892,
    isPrivate: false,
    tags: ['features', 'suggestions', 'feedback']
  }
];

const posts = [
  {
    id: 1,
    title: 'Welcome to Big Love Forum! 🎉',
    content: 'Hello everyone! Welcome to our brand new Telegram-style forum. This is a place where we can share ideas, get help, and build an amazing community together.\n\n**What makes this forum special:**\n- Beautiful Telegram-inspired interface\n- Real-time interactions\n- Rich text support with markdown\n- Emoji reactions and voting\n- Nested threading for discussions\n\nFeel free to explore, create posts, and engage with the community. We\'re excited to have you here!',
    authorId: 1,
    forumId: 1,
    createdAt: '2023-12-01T10:00:00Z',
    updatedAt: '2023-12-01T10:00:00Z',
    upvotes: 45,
    downvotes: 2,
    reactions: {
      '👍': 23,
      '🎉': 18,
      '❤️': 12,
      '🔥': 8
    },
    tags: ['welcome', 'announcement', 'community'],
    isPinned: true,
    metadata: {
      isAnnouncement: true,
      isSystemPost: false
    }
  },
  {
    id: 2,
    title: 'How to get the most out of Flutter development?',
    content: 'I\'ve been working with Flutter for a few months now, and I\'m looking for tips to improve my development workflow. Here are some specific areas I\'m interested in:\n\n1. **State management** - Currently using Provider, should I switch to Riverpod?\n2. **Code organization** - Best practices for large projects\n3. **Testing strategies** - Unit tests vs integration tests\n4. **Performance optimization** - Common pitfalls to avoid\n\nAny advice from experienced Flutter developers would be greatly appreciated! 🚀',
    authorId: 3,
    forumId: 2,
    createdAt: '2023-12-01T14:30:00Z',
    updatedAt: '2023-12-01T14:30:00Z',
    upvotes: 28,
    downvotes: 1,
    reactions: {
      '👍': 15,
      '🤔': 8,
      '💡': 5
    },
    tags: ['flutter', 'development', 'best-practices'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 3,
    title: 'VIP Member Exclusive: Advanced UI Patterns',
    content: 'Welcome VIP members! 👑\n\nThis week we\'re discussing advanced UI patterns that can take your applications to the next level:\n\n**Complex Animations:**\n- Hero transitions between screens\n- Custom physics-based animations\n- Coordinated multi-element animations\n\n**Advanced Layouts:**\n- Custom render objects\n- Flexible responsive designs\n- Performance-optimized list builders\n\n**Design Systems:**\n- Building consistent component libraries\n- Theme management at scale\n- Accessibility best practices\n\nLet\'s dive deep into these topics and share our experiences!',
    authorId: 2,
    forumId: 3,
    createdAt: '2023-12-01T16:45:00Z',
    updatedAt: '2023-12-01T16:45:00Z',
    upvotes: 12,
    downvotes: 0,
    reactions: {
      '🔥': 8,
      '💎': 6,
      '⭐': 4
    },
    tags: ['vip', 'ui', 'advanced', 'patterns'],
    isPinned: true,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 4,
    title: 'New Feature: Dark Mode Support! 🌙',
    content: '**ANNOUNCEMENT:** We\'ve just rolled out dark mode support across the entire platform!\n\n**What\'s new:**\n- System-wide dark theme\n- Automatic switching based on device settings\n- Customizable theme preferences\n- Better contrast for accessibility\n\n**How to enable:**\n1. Go to Settings → Appearance\n2. Select your preferred theme\n3. Enjoy the new look!\n\nWe\'d love to hear your feedback about the new dark mode. Report any issues or suggestions in the comments below.',
    authorId: 1,
    forumId: 4,
    createdAt: '2023-12-01T09:15:00Z',
    updatedAt: '2023-12-01T09:15:00Z',
    upvotes: 67,
    downvotes: 3,
    reactions: {
      '🌙': 25,
      '🔥': 20,
      '👍': 18,
      '✨': 12
    },
    tags: ['announcement', 'dark-mode', 'feature'],
    isPinned: true,
    metadata: {
      isAnnouncement: true,
      isSystemPost: true
    }
  },
  {
    id: 5,
    title: 'Feature Request: Voice Messages in Posts',
    content: 'Would it be possible to add voice message support to posts and replies?\n\n**Use cases:**\n- Explaining complex topics verbally\n- Accessibility for users with visual impairments\n- More personal communication\n- Multilingual support\n\n**Technical considerations:**\n- Audio file format (MP3, AAC?)\n- File size limits\n- Transcription capabilities\n- Mobile vs web playback\n\nWhat do you think? Would this be a valuable addition to the forum? Vote and share your thoughts! 🎙️',
    authorId: 4,
    forumId: 5,
    createdAt: '2023-12-01T11:20:00Z',
    updatedAt: '2023-12-01T11:20:00Z',
    upvotes: 34,
    downvotes: 8,
    reactions: {
      '🎙️': 15,
      '👍': 12,
      '🤔': 7
    },
    tags: ['feature-request', 'voice', 'accessibility'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 6,
    title: 'Help: App crashes when uploading images',
    content: 'Hi everyone,\n\nI\'m experiencing a strange issue where my Flutter app crashes whenever I try to upload images. Here are the details:\n\n**Environment:**\n- Flutter 3.16.0\n- Android 13 (API 33)\n- Using image_picker plugin\n\n**Error message:**\n```\nE/flutter (12345): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: PlatformException\n```\n\n**Steps to reproduce:**\n1. Open image picker\n2. Select any image from gallery\n3. App crashes immediately\n\nHas anyone encountered this before? Any suggestions would be appreciated! 🙏',
    authorId: 5,
    forumId: 2,
    createdAt: '2023-12-01T13:45:00Z',
    updatedAt: '2023-12-01T13:45:00Z',
    upvotes: 8,
    downvotes: 0,
    reactions: {
      '🤔': 5,
      '👍': 3
    },
    tags: ['help', 'crash', 'image-picker', 'android'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  }
];

const comments = [
  {
    id: 1,
    postId: 1,
    authorId: 2,
    content: 'Amazing work on this forum! The Telegram-style interface is incredibly smooth and intuitive. Looking forward to all the discussions we\'ll have here! 🚀',
    createdAt: '2023-12-01T10:15:00Z',
    upvotes: 12,
    downvotes: 0,
    reactions: {
      '👍': 8,
      '🎉': 4
    },
    parentId: null
  },
  {
    id: 2,
    postId: 1,
    authorId: 3,
    content: 'The real-time interactions are fantastic! I love how responsive everything feels.',
    createdAt: '2023-12-01T10:18:00Z',
    upvotes: 8,
    downvotes: 0,
    reactions: {
      '👍': 5,
      '⚡': 3
    },
    parentId: 1
  },
  {
    id: 3,
    postId: 2,
    authorId: 1,
    content: 'Great questions! For state management, I\'d definitely recommend Riverpod - it\'s more type-safe and has better performance. Here\'s a quick comparison:\n\n**Riverpod advantages:**\n- Compile-time safety\n- Better testing support\n- No context dependency\n- Built-in caching\n\nAs for code organization, consider using feature-based folders rather than layer-based ones. It scales much better!',
    createdAt: '2023-12-01T14:45:00Z',
    upvotes: 25,
    downvotes: 0,
    reactions: {
      '💡': 12,
      '👍': 8,
      '🔥': 5
    },
    parentId: null
  },
  {
    id: 4,
    postId: 2,
    authorId: 3,
    content: 'Thank you Alice! That\'s super helpful. Could you elaborate on the feature-based folder structure? I\'m currently using the traditional lib/models, lib/views, lib/controllers approach.',
    createdAt: '2023-12-01T14:52:00Z',
    upvotes: 6,
    downvotes: 0,
    reactions: {
      '🤔': 3,
      '👍': 2
    },
    parentId: 3
  },
  {
    id: 5,
    postId: 2,
    authorId: 1,
    content: 'Sure! Feature-based structure looks like this:\n\n```\nlib/\n  features/\n    authentication/\n      models/\n      providers/\n      screens/\n      widgets/\n    posts/\n      models/\n      providers/\n      screens/\n      widgets/\n  shared/\n    widgets/\n    utils/\n    constants/\n```\n\nThis way, everything related to a feature stays together, making it easier to maintain and test.',
    createdAt: '2023-12-01T15:02:00Z',
    upvotes: 18,
    downvotes: 0,
    reactions: {
      '🎯': 10,
      '📁': 8
    },
    parentId: 4
  },
  {
    id: 6,
    postId: 6,
    authorId: 3,
    content: 'I had a similar issue! Check if you have the correct permissions in your AndroidManifest.xml:\n\n```xml\n<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />\n<uses-permission android:name="android.permission.CAMERA" />\n```\n\nAlso, make sure you\'re handling permissions properly with the permission_handler package.',
    createdAt: '2023-12-01T14:00:00Z',
    upvotes: 15,
    downvotes: 0,
    reactions: {
      '🔧': 8,
      '💡': 7
    },
    parentId: null
  },
  {
    id: 7,
    postId: 6,
    authorId: 5,
    content: 'That worked! Thank you so much Charlie! I was missing the CAMERA permission. The app is working perfectly now. This community is amazing! 🙏✨',
    createdAt: '2023-12-01T14:30:00Z',
    upvotes: 10,
    downvotes: 0,
    reactions: {
      '🎉': 6,
      '👍': 4
    },
    parentId: 6
  },
  {
    id: 8,
    postId: 4,
    authorId: 4,
    content: 'The dark mode looks absolutely gorgeous! 🌙 The color scheme is perfect - easy on the eyes but still maintains excellent readability. Great job on the implementation!',
    createdAt: '2023-12-01T09:30:00Z',
    upvotes: 20,
    downvotes: 0,
    reactions: {
      '🌙': 12,
      '✨': 8
    },
    parentId: null
  },
  {
    id: 9,
    postId: 5,
    authorId: 2,
    content: 'Voice messages would be an excellent addition! As a moderator, I think this could really enhance accessibility and make the forum more inclusive. \n\nMaybe we could start with a pilot in the VIP lounge to test the feature? 🎙️',
    createdAt: '2023-12-01T11:45:00Z',
    upvotes: 12,
    downvotes: 1,
    reactions: {
      '🎙️': 6,
      '👍': 6
    },
    parentId: null
  }
];

// API Routes

// Users
app.get('/api/users', (req, res) => {
  res.json(users);
});

app.get('/api/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
});

// Forums
app.get('/api/forums', (req, res) => {
  res.json(forums);
});

app.get('/api/forums/:id', (req, res) => {
  const forum = forums.find(f => f.id === parseInt(req.params.id));
  if (!forum) return res.status(404).json({ error: 'Forum not found' });
  res.json(forum);
});

// Posts
app.get('/api/posts', (req, res) => {
  const { forumId, limit = 50, offset = 0 } = req.query;
  let filteredPosts = posts;
  
  if (forumId) {
    filteredPosts = posts.filter(p => p.forumId === parseInt(forumId));
  }
  
  // Add author information
  const postsWithAuthors = filteredPosts
    .slice(parseInt(offset), parseInt(offset) + parseInt(limit))
    .map(post => ({
      ...post,
      author: users.find(u => u.id === post.authorId)
    }));
  
  res.json(postsWithAuthors);
});

app.get('/api/posts/:id', (req, res) => {
  const post = posts.find(p => p.id === parseInt(req.params.id));
  if (!post) return res.status(404).json({ error: 'Post not found' });
  
  const postWithAuthor = {
    ...post,
    author: users.find(u => u.id === post.authorId)
  };
  
  res.json(postWithAuthor);
});

// Comments
app.get('/api/posts/:postId/comments', (req, res) => {
  const postComments = comments
    .filter(c => c.postId === parseInt(req.params.postId))
    .map(comment => ({
      ...comment,
      author: users.find(u => u.id === comment.authorId)
    }));
  
  res.json(postComments);
});

// Create new post
app.post('/api/posts', (req, res) => {
  const { title, content, forumId, authorId, tags } = req.body;
  
  const newPost = {
    id: posts.length + 1,
    title,
    content,
    authorId: parseInt(authorId),
    forumId: parseInt(forumId),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    upvotes: 0,
    downvotes: 0,
    reactions: {},
    tags: tags || [],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  };
  
  posts.push(newPost);
  
  const postWithAuthor = {
    ...newPost,
    author: users.find(u => u.id === newPost.authorId)
  };
  
  res.status(201).json(postWithAuthor);
});

// Create new comment
app.post('/api/posts/:postId/comments', (req, res) => {
  const { content, authorId, parentId } = req.body;
  
  const newComment = {
    id: comments.length + 1,
    postId: parseInt(req.params.postId),
    content,
    authorId: parseInt(authorId),
    createdAt: new Date().toISOString(),
    upvotes: 0,
    downvotes: 0,
    reactions: {},
    parentId: parentId ? parseInt(parentId) : null
  };
  
  comments.push(newComment);
  
  const commentWithAuthor = {
    ...newComment,
    author: users.find(u => u.id === newComment.authorId)
  };
  
  res.status(201).json(commentWithAuthor);
});

// Vote on post
app.post('/api/posts/:id/vote', (req, res) => {
  const { type } = req.body; // 'up' or 'down'
  const post = posts.find(p => p.id === parseInt(req.params.id));
  
  if (!post) return res.status(404).json({ error: 'Post not found' });
  
  if (type === 'up') {
    post.upvotes++;
  } else if (type === 'down') {
    post.downvotes++;
  }
  
  res.json({ upvotes: post.upvotes, downvotes: post.downvotes });
});

// Add reaction to post
app.post('/api/posts/:id/react', (req, res) => {
  const { emoji } = req.body;
  const post = posts.find(p => p.id === parseInt(req.params.id));
  
  if (!post) return res.status(404).json({ error: 'Post not found' });
  
  if (post.reactions[emoji]) {
    post.reactions[emoji]++;
  } else {
    post.reactions[emoji] = 1;
  }
  
  res.json(post.reactions);
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    endpoints: [
      'GET /api/users',
      'GET /api/users/:id',
      'GET /api/forums',
      'GET /api/forums/:id',
      'GET /api/posts',
      'GET /api/posts/:id',
      'GET /api/posts/:postId/comments',
      'POST /api/posts',
      'POST /api/posts/:postId/comments',
      'POST /api/posts/:id/vote',
      'POST /api/posts/:id/react'
    ]
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Big Love Forum Demo API Server running on http://localhost:${PORT}`);
  console.log(`📡 API Base URL: http://localhost:${PORT}/api`);
  console.log(`💾 Demo data loaded:`);
  console.log(`   - ${users.length} users`);
  console.log(`   - ${forums.length} forums`);
  console.log(`   - ${posts.length} posts`);
  console.log(`   - ${comments.length} comments`);
  console.log(`\n🌐 Test the API:`);
  console.log(`   curl http://localhost:${PORT}/api/health`);
});
