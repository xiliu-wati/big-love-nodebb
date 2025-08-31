const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// 中文演示数据
const users = [
  {
    id: 1,
    username: 'admin_alice',
    email: 'alice@dalove.com',
    displayName: '艾丽丝·王',
    bio: '大爱社区管理员，致力于传播正能量',
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
    username: 'moderator_bob',
    email: 'bob@dalove.com',
    displayName: '鲍勃·李',
    bio: '大爱版主，分享爱与希望',
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
    email: 'charlie@dalove.com',
    displayName: '查理·陈',
    bio: '热心的大爱社区成员，喜欢分享生活中的美好',
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
    email: 'diana@dalove.com',
    displayName: '戴安娜·张',
    bio: '爱心设计师，用设计传递温暖',
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
    email: 'erik@dalove.com',
    displayName: '埃里克·刘',
    bio: '大爱社区新成员，渴望学习和成长',
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
  },
  {
    id: 6,
    username: 'maria_love',
    email: 'maria@dalove.com',
    displayName: '玛丽亚·赵',
    bio: '传播大爱精神，关爱每一个人',
    avatarUrl: 'https://i.pravatar.cc/150?img=6',
    role: 'user',
    status: 'online',
    joinedAt: '2023-09-08T11:25:00Z',
    stats: {
      totalPosts: 43,
      totalReactions: 178,
      forumsJoined: 3,
      reputation: 312
    }
  }
];

const forums = [
  {
    id: 1,
    name: '大爱推荐',
    description: '分享值得推荐的好物、好地方、好人好事',
    icon: '💖',
    category: 'recommendation',
    memberCount: 1580,
    postCount: 2340,
    isPrivate: false,
    tags: ['推荐', '分享', '好物']
  },
  {
    id: 2,
    name: '大爱场所',
    description: '推荐温馨美好的地方，分享生活中的美丽角落',
    icon: '🏞️',
    category: 'places',
    memberCount: 1250,
    postCount: 1876,
    isPrivate: false,
    tags: ['场所', '地点', '旅行', '美景']
  },
  {
    id: 3,
    name: '日常生活',
    description: '分享生活中的点点滴滴，传递正能量',
    icon: '☀️',
    category: 'general',
    memberCount: 2150,
    postCount: 4320,
    isPrivate: false,
    tags: ['生活', '日常', '分享']
  },
  {
    id: 4,
    name: '大爱互助',
    description: '互相帮助，解决生活中的困难和问题',
    icon: '🤝',
    category: 'support',
    memberCount: 890,
    postCount: 1560,
    isPrivate: false,
    tags: ['互助', '帮助', '支持']
  },
  {
    id: 5,
    name: 'VIP会员区',
    description: 'VIP会员专属讨论区，分享更深层次的大爱思考',
    icon: '👑',
    category: 'vip',
    memberCount: 65,
    postCount: 298,
    isPrivate: true,
    tags: ['VIP', '专属', '深度']
  },
  {
    id: 6,
    name: '管理员专区',
    description: '管理员发布公告和重要通知的地方',
    icon: '⚡',
    category: 'admin',
    memberCount: 12,
    postCount: 87,
    isPrivate: true,
    tags: ['管理', '公告', '官方']
  }
];

const posts = [
  {
    id: 1,
    title: '欢迎来到大爱社区！🎉',
    content: '各位朋友，欢迎来到我们全新的大爱社区！这里是一个充满爱心、温暖和正能量的地方，我们可以在这里分享美好、互相帮助、共同成长。\n\n**大爱社区的特色：**\n- 🎨 美观的界面设计\n- 💬 实时互动交流\n- ❤️ 表情反应和点赞\n- 🌟 嵌套评论讨论\n- 🏷️ 丰富的标签分类\n\n让我们一起在这个温暖的社区中传递爱心，分享生活中的美好时光！期待与每一位朋友的相遇和交流。\n\n愿大爱精神在这里生根发芽，愿每个人都能在这里找到属于自己的温暖角落。💕',
    authorId: 1,
    forumId: 3,
    createdAt: '2023-12-01T10:00:00Z',
    updatedAt: '2023-12-01T10:00:00Z',
    upvotes: 68,
    downvotes: 1,
    reactions: {
      '❤️': 35,
      '👍': 28,
      '🎉': 22,
      '🌟': 18,
      '😊': 15
    },
    tags: ['欢迎', '公告', '社区'],
    isPinned: true,
    metadata: {
      isAnnouncement: true,
      isSystemPost: false
    }
  },
  {
    id: 2,
    title: '推荐一家超棒的咖啡馆 ☕',
    content: '今天想和大家分享一个我偶然发现的宝藏咖啡馆——"温心小筑"！\n\n**地址：** 市中心文艺街15号\n**营业时间：** 上午9点到晚上10点\n\n**为什么推荐：**\n☕ **咖啡香醇** - 老板是专业咖啡师，每一杯都用心制作\n🍰 **甜品精美** - 手工制作的蛋糕和点心，颜值和味道都在线\n📚 **环境温馨** - 有很多书籍，适合安静地读书或工作\n💝 **服务贴心** - 店员都很友善，会记住常客的喜好\n🎵 **音乐舒缓** - 轻柔的背景音乐让人放松\n\n店里还有一只超可爱的橘猫叫"大橘"，特别亲人！如果你也是咖啡爱好者，一定要去试试看。记得告诉我你们的体验哦～\n\n#咖啡推荐 #温心小筑',
    authorId: 4,
    forumId: 1,
    createdAt: '2023-12-01T14:30:00Z',
    updatedAt: '2023-12-01T14:30:00Z',
    upvotes: 42,
    downvotes: 0,
    reactions: {
      '☕': 25,
      '😍': 18,
      '👍': 15,
      '🤤': 12,
      '❤️': 8
    },
    tags: ['咖啡', '推荐', '美食', '温心小筑'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 3,
    title: '森林公园的绝美秋景 🍂',
    content: '昨天和朋友去了城郊的枫叶森林公园，被那里的秋色深深震撼了！\n\n**最佳观赏时间：** 现在到11月底\n**门票：** 免费开放\n**交通：** 地铁3号线转18路公交车\n\n**亮点推荐：**\n🍁 **枫叶大道** - 两旁都是火红的枫树，像童话世界\n🌊 **湖心小岛** - 可以租小船划过去，湖水清澈如镜\n🏔️ **观景台** - 能俯瞰整个公园的全景，超级壮观\n🦌 **小动物** - 运气好的话能看到小松鼠和野兔\n📸 **拍照圣地** - 随手一拍都是大片既视感\n\n**温馨提示：**\n- 记得带保温杯，山里温差大\n- 穿舒适的运动鞋，有些山路比较崎岖\n- 最好是晴天去，阳光透过叶子的感觉特别美\n\n这个季节的大自然真的太治愈了，强烈推荐大家去走走，放松心情，感受大自然的美好！',
    authorId: 3,
    forumId: 2,
    createdAt: '2023-12-01T16:45:00Z',
    updatedAt: '2023-12-01T16:45:00Z',
    upvotes: 38,
    downvotes: 2,
    reactions: {
      '🍂': 22,
      '😍': 18,
      '📸': 15,
      '🌟': 12,
      '❤️': 10
    },
    tags: ['秋景', '森林公园', '旅行', '摄影'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 4,
    title: 'VIP专享：心灵成长分享会 💎',
    content: '亲爱的VIP会员们，欢迎参加我们本月的心灵成长分享会！\n\n**主题：** "在忙碌生活中保持内心平静的艺术"\n**时间：** 本周六下午2点-4点\n**形式：** 线上分享+互动讨论\n\n**分享内容：**\n🧘 **冥想入门** - 简单易学的冥想技巧\n📚 **好书推荐** - 心灵成长类书籍分享\n🌱 **生活智慧** - 如何在日常中保持正念\n💬 **经验交流** - VIP会员们的心得分享\n\n**特别嘉宾：** 心理咨询师李老师将为我们分享专业见解\n\n这次分享会限定VIP会员参与，我们可以在这个私密的空间里深度交流，互相支持成长。每个人的经历都是宝贵的财富，期待听到大家的智慧分享。\n\n报名请私信我，名额有限，先到先得！\n\n#VIP专享 #心灵成长 #冥想',
    authorId: 2,
    forumId: 5,
    createdAt: '2023-12-01T11:20:00Z',
    updatedAt: '2023-12-01T11:20:00Z',
    upvotes: 18,
    downvotes: 0,
    reactions: {
      '💎': 12,
      '🧘': 10,
      '❤️': 8,
      '🌟': 6,
      '🙏': 4
    },
    tags: ['VIP', '心灵成长', '冥想', '分享会'],
    isPinned: true,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 5,
    title: '【公告】社区新功能上线通知 🚀',
    content: '**重要公告：** 大爱社区迎来重大更新！\n\n**新增功能：**\n🎨 **深色模式** - 保护您的眼睛，夜间浏览更舒适\n🔔 **智能通知** - 重要消息不错过，可自定义提醒设置\n📱 **移动端优化** - 手机浏览体验全面升级\n🏷️ **标签系统** - 更好地分类和查找感兴趣的内容\n💬 **私信功能** - 可以与其他用户进行私密对话\n\n**如何使用：**\n1. 点击右上角设置图标\n2. 选择"外观设置"可切换深色模式\n3. 在"通知设置"中自定义提醒偏好\n4. 使用标签功能更好地整理您的帖子\n\n**反馈收集：**\n如果您在使用过程中遇到任何问题或有改进建议，请随时联系我们。您的反馈是我们不断改进的动力！\n\n感谢所有用户对大爱社区的支持和信任。我们会继续努力，为大家创造更好的交流平台！\n\n#系统更新 #新功能 #社区公告',
    authorId: 1,
    forumId: 6,
    createdAt: '2023-12-01T09:15:00Z',
    updatedAt: '2023-12-01T09:15:00Z',
    upvotes: 56,
    downvotes: 2,
    reactions: {
      '🚀': 28,
      '👍': 22,
      '🎉': 18,
      '❤️': 15,
      '✨': 12
    },
    tags: ['公告', '新功能', '系统更新'],
    isPinned: true,
    metadata: {
      isAnnouncement: true,
      isSystemPost: true
    }
  },
  {
    id: 6,
    title: '求助：如何安慰失落的朋友？',
    content: '朋友们好，我遇到了一个情况，希望大家能给我一些建议。\n\n我有一个很好的朋友最近工作上遇到了挫折，整个人变得很消沉。我想帮助她走出阴霾，但是不知道该怎么做才好。\n\n**目前的情况：**\n- 她平时很开朗，但现在话变得很少\n- 不太愿意出门，总是说很累\n- 对以前喜欢的事情都失去了兴趣\n- 我尝试约她出去散心，但她总是拒绝\n\n**我的困惑：**\n1. 是应该给她空间让她自己调整，还是主动关心？\n2. 用什么方式安慰比较好？说话还是行动？\n3. 如何判断什么时候需要建议她寻求专业帮助？\n\n**我已经尝试过的：**\n✓ 经常发关心的消息\n✓ 给她做了她爱吃的小点心\n✓ 推荐了一些励志的文章和视频\n\n但感觉效果不太明显，我真的很担心她。有没有经历过类似情况的朋友能分享一下经验？或者给我一些实用的建议？\n\n谢谢大家！🙏',
    authorId: 6,
    forumId: 4,
    createdAt: '2023-12-01T13:45:00Z',
    updatedAt: '2023-12-01T13:45:00Z',
    upvotes: 24,
    downvotes: 0,
    reactions: {
      '🤗': 15,
      '❤️': 12,
      '🙏': 8,
      '💪': 6,
      '☀️': 3
    },
    tags: ['求助', '友情', '心理健康', '安慰'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 7,
    title: '今天遇到的暖心小事 💕',
    content: '今天在地铁上发生了一件特别暖心的事情，想和大家分享一下。\n\n早高峰的地铁特别拥挤，我旁边站着一位抱着小宝宝的年轻妈妈。小宝宝大概一岁多，一直在哭闹，妈妈看起来很疲惫，不断地轻声哄着孩子。\n\n这时候，一位坐着的大爷主动站起来，微笑着对那位妈妈说："来，坐这里吧，带孩子不容易。"妈妈很感动地连声道谢。\n\n更暖心的是，旁边的其他乘客也开始主动帮忙：\n- 一位阿姨从包里拿出湿纸巾给妈妈用\n- 一个小女孩拿出自己的小玩具逗宝宝开心\n- 还有人主动让出更多空间\n\n小宝宝很快就不哭了，车厢里的氛围变得特别温暖。那一刻，我觉得这个世界充满了善意。\n\n**感悟：**\n有时候一个小小的善举，就能让人感受到巨大的温暖。我们每个人都可以成为别人生活中的一束光。\n\n希望这份善意能像涟漪一样传播下去，让更多人感受到爱的力量。\n\n你们最近有遇到什么暖心的事情吗？一起分享吧！',
    authorId: 5,
    forumId: 3,
    createdAt: '2023-12-01T18:20:00Z',
    updatedAt: '2023-12-01T18:20:00Z',
    upvotes: 35,
    downvotes: 0,
    reactions: {
      '❤️': 22,
      '😊': 18,
      '🥰': 15,
      '👍': 12,
      '🌟': 8
    },
    tags: ['暖心', '善意', '地铁', '正能量'],
    isPinned: false,
    metadata: {
      isAnnouncement: false,
      isSystemPost: false
    }
  },
  {
    id: 8,
    title: '推荐几本治愈心灵的好书 📚',
    content: '最近读了几本特别棒的书，想和爱读书的朋友们分享一下：\n\n**《小王子》- 圣埃克苏佩里**\n⭐ 评分：9.8/10\n💭 感悟：永远保持童真和对美好事物的敏感\n🎯 适合：所有年龄段，特别是感到疲惫时读\n\n**《被讨厌的勇气》- 岸见一郎**\n⭐ 评分：9.5/10\n💭 感悟：学会接纳自己，不为别人的期望而活\n🎯 适合：缺乏自信、过度在意他人看法的人\n\n**《活着》- 余华**\n⭐ 评分：9.7/10\n💭 感悟：生命的韧性和希望的力量\n🎯 适合：想要理解生命意义的人\n\n**《百年孤独》- 加西亚·马尔克斯**\n⭐ 评分：9.6/10\n💭 感悟：时间的循环和人性的复杂\n🎯 适合：喜欢文学性强的作品的读者\n\n**《当下的力量》- 埃克哈特·托利**\n⭐ 评分：9.4/10\n💭 感悟：专注当下，摆脱焦虑和痛苦\n🎯 适合：容易焦虑、想要学习正念的人\n\n**阅读心得：**\n每一本书都像是一次心灵的旅行，让我们在文字中找到力量和智慧。希望这些书也能给你们带来启发和温暖。\n\n你们最近在读什么好书呢？欢迎在评论区推荐给大家！',
    authorId: 3,
    forumId: 1,
    createdAt: '2023-12-01T15:10:00Z',
    updatedAt: '2023-12-01T15:10:00Z',
    upvotes: 29,
    downvotes: 1,
    reactions: {
      '📚': 18,
      '❤️': 15,
      '👍': 12,
      '✨': 8,
      '🤔': 5
    },
    tags: ['读书', '推荐', '心灵', '治愈'],
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
    content: '欢迎大家来到大爱社区！这里的界面设计真的很温馨，让人感觉很舒服。期待在这里认识更多志同道合的朋友，一起传递正能量！🌟',
    createdAt: '2023-12-01T10:15:00Z',
    upvotes: 18,
    downvotes: 0,
    reactions: {
      '👍': 12,
      '❤️': 8,
      '😊': 6
    },
    parentId: null
  },
  {
    id: 2,
    postId: 1,
    authorId: 3,
    content: '真的很喜欢这种温暖的氛围，感觉这里每个人都很友善。希望我们都能在这个大家庭里找到属于自己的快乐！',
    createdAt: '2023-12-01T10:18:00Z',
    upvotes: 12,
    downvotes: 0,
    reactions: {
      '🥰': 8,
      '👍': 5,
      '💕': 3
    },
    parentId: 1
  },
  {
    id: 3,
    postId: 2,
    authorId: 1,
    content: '哇，这家咖啡馆听起来太棒了！我也是咖啡重度爱好者，一定要去试试。特别是你提到的那只橘猫，听起来就很治愈呢～ ☕🐱',
    createdAt: '2023-12-01T14:45:00Z',
    upvotes: 15,
    downvotes: 0,
    reactions: {
      '☕': 8,
      '🐱': 6,
      '😍': 4,
      '👍': 3
    },
    parentId: null
  },
  {
    id: 4,
    postId: 2,
    authorId: 4,
    content: '艾丽丝，你一定要去！大橘真的超级可爱，而且很亲人。老板娘说它特别喜欢和客人互动，有时候还会跳到桌子上"监督"你喝咖啡呢～',
    createdAt: '2023-12-01T14:52:00Z',
    upvotes: 10,
    downvotes: 0,
    reactions: {
      '🐱': 6,
      '😂': 4,
      '❤️': 3
    },
    parentId: 3
  },
  {
    id: 5,
    postId: 3,
    authorId: 5,
    content: '看你的描述就能感受到那里的美！秋天真的是最浪漫的季节，这周末我也想去走走。请问从观景台看日落的效果怎么样？',
    createdAt: '2023-12-01T17:02:00Z',
    upvotes: 8,
    downvotes: 0,
    reactions: {
      '🌅': 5,
      '😍': 3,
      '🍂': 2
    },
    parentId: null
  },
  {
    id: 6,
    postId: 3,
    authorId: 3,
    content: '埃里克，日落的时候超级美！金色的阳光透过红叶，整个森林都像在发光一样。建议你下午4点左右到观景台，可以拍到最美的夕阳照片！',
    createdAt: '2023-12-01T17:10:00Z',
    upvotes: 12,
    downvotes: 0,
    reactions: {
      '✨': 7,
      '📸': 5,
      '😍': 4
    },
    parentId: 5
  },
  {
    id: 7,
    postId: 6,
    authorId: 2,
    content: '我之前也帮助过处在低谷期的朋友。我的经验是：陪伴比建议更重要。不用说太多大道理，就是让她知道无论什么时候，你都在她身边。有时候一个拥抱胜过千言万语。💗',
    createdAt: '2023-12-01T14:00:00Z',
    upvotes: 22,
    downvotes: 0,
    reactions: {
      '🤗': 12,
      '❤️': 8,
      '👍': 6
    },
    parentId: null
  },
  {
    id: 8,
    postId: 6,
    authorId: 6,
    content: '鲍勃说得真好！我确实有时候太着急想要"修复"她的情绪了。也许我应该更耐心一些，就是单纯地陪在她身边。谢谢你的建议！',
    createdAt: '2023-12-01T14:15:00Z',
    upvotes: 15,
    downvotes: 0,
    reactions: {
      '🙏': 8,
      '💕': 5,
      '😊': 4
    },
    parentId: 7
  },
  {
    id: 9,
    postId: 7,
    authorId: 4,
    content: '读完你的分享，我心里也暖暖的！这种善意的连锁反应真的很感人。我记得有一次在雨天，一个陌生人主动把伞借给我，那种温暖至今都记得。善良真的会传染呢～',
    createdAt: '2023-12-01T18:45:00Z',
    upvotes: 18,
    downvotes: 0,
    reactions: {
      '☔': 8,
      '❤️': 6,
      '😊': 5,
      '👍': 4
    },
    parentId: null
  },
  {
    id: 10,
    postId: 8,
    authorId: 1,
    content: '谢谢查理的推荐！《小王子》我读过好多遍，每次读都有新的感悟。最近我在读《人间值得》，也是很治愈的一本书。90岁奶奶的人生智慧让人感动。',
    createdAt: '2023-12-01T15:30:00Z',
    upvotes: 14,
    downvotes: 0,
    reactions: {
      '📚': 8,
      '👵': 6,
      '💕': 4
    },
    parentId: null
  },
  {
    id: 11,
    postId: 8,
    authorId: 3,
    content: '《人间值得》我也看过！中村恒子奶奶的话真的很有智慧。她说"人生不必太用力，坦率地接受每一天"，这句话帮我度过了很多焦虑的时刻。',
    createdAt: '2023-12-01T15:35:00Z',
    upvotes: 16,
    downvotes: 0,
    reactions: {
      '🧘': 9,
      '✨': 7,
      '❤️': 5
    },
    parentId: 10
  },
  {
    id: 12,
    postId: 4,
    authorId: 1,
    content: '这次分享会的主题太及时了！现在生活节奏这么快，确实需要学会让内心平静下来。李老师的分享一定很精彩，期待听到大家的心得。',
    createdAt: '2023-12-01T11:45:00Z',
    upvotes: 8,
    downvotes: 0,
    reactions: {
      '🧘': 5,
      '👍': 3,
      '💎': 2
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
  if (!user) return res.status(404).json({ error: '用户未找到' });
  res.json(user);
});

// Forums
app.get('/api/forums', (req, res) => {
  res.json(forums);
});

app.get('/api/forums/:id', (req, res) => {
  const forum = forums.find(f => f.id === parseInt(req.params.id));
  if (!forum) return res.status(404).json({ error: '论坛未找到' });
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
  if (!post) return res.status(404).json({ error: '帖子未找到' });
  
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
  
  if (!post) return res.status(404).json({ error: '帖子未找到' });
  
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
  
  if (!post) return res.status(404).json({ error: '帖子未找到' });
  
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
    status: '正常', 
    timestamp: new Date().toISOString(),
    message: '大爱社区后端服务运行正常',
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
  console.log(`🚀 大爱社区演示API服务器运行在 http://localhost:${PORT}`);
  console.log(`📡 API基础URL: http://localhost:${PORT}/api`);
  console.log(`💾 中文演示数据已加载:`);
  console.log(`   - ${users.length} 位用户`);
  console.log(`   - ${forums.length} 个论坛`);
  console.log(`   - ${posts.length} 个帖子`);
  console.log(`   - ${comments.length} 条评论`);
  console.log(`\n🌐 测试API:`);
  console.log(`   curl http://localhost:${PORT}/api/health`);
});