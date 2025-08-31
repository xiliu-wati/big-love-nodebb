# 大爱社区 - Telegram风格Flutter应用设计

## 概述
本文档概述了大爱社区应用的全面重新设计，采用Telegram风格界面，专注于现代UI/UX模式、改进的导航和增强的用户交互。

## 当前状态分析
- 简单的基于列表的论坛界面
- 有限交互的基本帖子卡片
- 底部导航栏
- 标准Material Design组件

## 新设计愿景 - 具有Telegram美学的论坛

### 1. 应用架构

#### 主从布局（以论坛为中心）
- **左侧边栏**：论坛分类、带角色徽章的用户资料、导航
- **主内容区**：论坛帖子列表、单个帖子主题、帖子创建
- **响应式设计**：适应不同屏幕尺寸，优化论坛布局

#### 导航流程
```
应用框架 → 侧边栏（论坛分类） → 选定论坛（帖子列表） → 单个帖子 → 回复主题
```

#### 论坛结构集成
- **传统论坛功能**：帖子、回复、用户角色、分类、投票
- **Telegram UI风格**：简洁设计、流畅动画、现代交互
- **混合方法**：论坛功能与聊天应用美学

### 2. 左侧边栏设计

#### 资料部分（顶部）
- 用户头像（大，圆形）
- 用户名和在线状态
- 快速访问个人设置
- 暗色/亮色主题切换

#### 论坛分类列表（中间）
- 可滚动的论坛分类和单个论坛列表
- 每个论坛项目显示：
  - 带分类颜色的论坛图标/头像
  - 带访问级别指示器的论坛名称：
    - 🏛️ 大爱场所（🔒 私人）
    - ⭐ 大爱推荐（👑 VIP专属）
    - 🛡️ 管理员专区（🛡️ 管理员）
  - 最新帖子预览（标题 + 作者）
  - 最后活动时间戳
  - 未读帖子数量徽章
  - 总帖子数和活跃成员数

#### 导航菜单（底部）
- 设置齿轮图标
- 搜索图标
- 创建新论坛（管理员）
- 帮助/支持

### 3. 主内容区域

#### 论坛列表视图（未选择论坛）
- 欢迎消息
- 精选论坛网格
- 最近活动动态
- 快速操作（加入论坛、创建帖子）

#### 选定论坛视图（论坛帖子列表）
- **论坛头部栏**：
  - 论坛名称、描述和分类
  - 成员数量、在线用户和版主
  - 论坛规则和置顶帖子
  - 论坛内搜索、排序选项

- **帖子信息流区域**：
  - 论坛帖子列表（非聊天消息）
  - 每个帖子显示：标题、带角色徽章的作者、预览、统计
  - 帖子分组：置顶、最新、热门
  - 无限滚动和分页
  - 按标签、分类、帖子类型过滤

- **创建帖子栏**：
  - "开始新讨论..."提示
  - 帖子内容的富文本编辑器
  - 分类和标签选择
  - 文件/图片附件
  - 发布帖子按钮

### 4. 论坛帖子设计（Telegram风格卡片）

#### 帖子卡片布局
- **帖子头部部分**：
  - 带角色徽章的作者头像（👑 VIP金色，🛡️ 管理员红色，👤 用户灰色）
  - 帖子标题（突出显示，可点击）
  - 用户名、角色和声誉分数
  - 发布时间戳和最后活动
  - 分类标签和帖子类型指示器

- **帖子内容部分**：
  - 带格式的富文本内容
  - 图片画廊和媒体嵌入
  - 带语法高亮的代码块
  - 文件附件和下载
  - 链接预览和嵌入

- **帖子统计和操作**：
  - 点赞/点踩计数和按钮
  - 回复数量和"查看回复"按钮
  - 查看次数和分享统计
  - 收藏、举报和更多选项菜单
  - 表情反应栏（👍 ❤️ 😂 😮 等）

#### 反应系统
- **快速反应**：👍 👎 ❤️ 😂 😮 😢 😡
- **自定义表情选择器**：完整的表情选择
- **反应计数**：显示总数和明细
- **用户反应**：突出显示用户的反应

#### 论坛回复树形结构
- **嵌套回复结构**：多层级主题（3-4层深度）
- **回复排序选项**：最佳回复优先、最新、最旧、按角色优先级
- **主题管理**：折叠/展开长回复链
- **回复功能**：引用特定文本、提及用户、回复通知
- **角色优先级**：VIP和管理员回复高亮显示和优先
- **回复统计**：单个回复投票和嵌套回复计数

### 5. 视觉设计语言

#### 配色方案
```
主色: #0088cc (Telegram蓝)
辅助色: #17212b (深色主题侧边栏)
背景: #ffffff (亮色) / #212d3c (暗色)
表面: #f5f5f5 (亮色) / #2e3a4b (暗色)
文本: #000000 (亮色) / #ffffff (暗色)
强调色: #50a2e9 (链接和操作)
```

#### 字体排版
```
标题: SF Pro Display / Roboto (24sp, 粗体)
副标题: SF Pro Display / Roboto (18sp, 中等)
正文: SF Pro Text / Roboto (16sp, 常规)
说明文字: SF Pro Text / Roboto (14sp, 常规)
```

#### 组件样式
- **圆角**：卡片12px，按钮8px
- **阴影**：微妙的高度(2dp-8dp)
- **动画**：流畅的过渡(200-300ms)
- **图标**：线性风格，一致的描边宽度

### 6. 移动端响应式设计

#### 竖屏模式（主要）
- 全宽侧边栏滑过内容
- 滑动手势导航
- 悬浮操作按钮快速发帖

#### 横屏模式
- 并排布局
- 侧边栏始终可见
- 优化的内容区域

#### 平板/大屏幕
- 持久化侧边栏
- 多面板布局
- 增强的交互

### 7. 用户交互

#### 手势操作
- **向右滑动**：打开/关闭侧边栏
- **在帖子上左滑**：快速回复
- **长按帖子**：上下文菜单
- **下拉刷新**：刷新论坛内容
- **双指缩放**：媒体内容

#### 键盘快捷键（未来）
- **Cmd/Ctrl + K**：搜索
- **Cmd/Ctrl + N**：新帖子
- **Esc**：关闭模态框/面板

### 8. Enhanced Features

#### Real-time Features
- Live message updates
- Typing indicators
- Online presence
- Push notifications

#### Rich Content Support
- **Media Gallery**: Image carousels
- **File Attachments**: Documents, PDFs
- **Voice Messages**: Audio recording/playback
- **Code Blocks**: Syntax highlighting
- **Polls**: Interactive voting

#### Accessibility
- Screen reader support
- High contrast mode
- Keyboard navigation
- Text scaling support

### 9. Data Models Updates

#### Forum Model
```dart
class Forum {
  final int id;
  final String name;
  final String description;
  final String? avatarUrl;
  final int memberCount;
  final int onlineCount;
  final DateTime lastActivity;
  final int unreadCount;
  final ForumType type; // public, private, admin-only
  final List<ForumTag> tags;
}
```

#### Enhanced Post Model
```dart
class Post {
  final int id;
  final String content;
  final User author;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<MediaAttachment> attachments;
  final Map<String, int> reactions;
  final List<Post> replies;
  final Post? parentPost;
  final bool isPinned;
  final PostType type; // text, image, poll, announcement
}
```

#### Reaction Model
```dart
class Reaction {
  final int id;
  final String emoji;
  final User user;
  final DateTime createdAt;
}
```

### 10. Implementation Phases

#### Phase 1: Core Layout
- App shell with sidebar/main content
- Basic navigation structure
- Theme system setup

#### Phase 2: Forum List & Selection
- Sidebar forum list
- Forum selection logic
- Basic post display

#### Phase 3: Message Interface
- Chat-like post display
- Message input system
- Basic interactions

#### Phase 4: Enhanced Features
- Reactions system
- Reply threading
- Media support

#### Phase 5: Polish & Performance
- Animations and transitions
- Performance optimization
- Testing and bug fixes

### 11. Technical Considerations

#### State Management
- Use Riverpod for complex state
- Cached data for offline access
- Real-time updates via WebSockets

#### Performance
- Lazy loading for large forums
- Image caching and optimization
- Efficient list rendering

#### Accessibility
- Semantic widgets
- Screen reader labels
- Keyboard navigation support

## Next Steps
1. Review and approve design
2. Update data models
3. Create component library
4. Implement phase by phase
5. User testing and iteration

---

This design transforms the app from a simple forum into a modern, Telegram-style communication platform while maintaining the core community features.
