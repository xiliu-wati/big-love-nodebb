# Telegram-Style Design Components

## Component Library Design

### 1. Color Palette

#### Light Theme
```
Primary Blue: #0088cc
Primary Dark: #006699  
Secondary: #17212b
Background: #ffffff
Surface: #f5f5f5
Surface Variant: #e8e8e8
On Surface: #1c1c1e
On Surface Variant: #666666
Border: #d1d1d6
Success: #34c759
Warning: #ff9500
Error: #ff3b30
```

#### Dark Theme
```
Primary Blue: #50a2e9
Primary Dark: #0088cc
Secondary: #17212b  
Background: #212d3c
Surface: #2e3a4b
Surface Variant: #3a4a5c
On Surface: #ffffff
On Surface Variant: #a8a8a8
Border: #4a5a6b
Success: #32d74b
Warning: #ff9f0a
Error: #ff453a
```

### 2. Typography Scale

```
Display Large: 57sp, Bold
Display Medium: 45sp, Bold
Display Small: 36sp, Bold

Headline Large: 32sp, Bold  
Headline Medium: 28sp, Bold
Headline Small: 24sp, Bold

Title Large: 22sp, SemiBold
Title Medium: 16sp, SemiBold
Title Small: 14sp, SemiBold

Body Large: 16sp, Regular
Body Medium: 14sp, Regular
Body Small: 12sp, Regular

Label Large: 14sp, Medium
Label Medium: 12sp, Medium
Label Small: 11sp, Medium
```

### 3. Core Components

#### App Shell
```
- Left Sidebar (250px width on desktop)
- Main Content Area (flexible)
- Overlay for mobile sidebar
- Status bar with theme-aware colors
```

#### Sidebar Profile Section
```
Height: 80px
- Circular avatar (48px)
- Username (Title Medium)
- Status indicator (8px dot)
- Online/Offline text (Label Small)
```

#### Forum List Item
```
Height: 72px
Padding: 16px horizontal, 8px vertical
- Forum avatar (40px circular)
- Forum name (Body Large)
- Last message preview (Body Small, 2 lines max)
- Timestamp (Label Small)
- Unread badge (circular, Primary Blue)
```

#### Message/Post Card
```
Padding: 16px
Margin: 4px vertical
- Author avatar (32px)
- Username with role badge
- Timestamp (top right)
- Content (rich text)
- Media gallery (if present)
- Reactions bar
- Reply thread (nested)
```

#### Reaction Button
```
Size: 32px x 24px
Border radius: 12px
- Emoji (16px)
- Count (Label Small)
- Active state: Primary Blue background
- Inactive state: Surface background
```

#### Message Input Bar
```
Height: 56px (minimum)
Padding: 8px horizontal
- Text input (expandable)
- Emoji button (40px)
- Attachment button (40px)  
- Send button (40px, Primary Blue)
```

### 4. Interactive States

#### Hover States
```
Forum List Item: Surface Variant background
Message: Subtle border highlight
Buttons: Slight opacity change (0.8)
```

#### Active States
```
Selected Forum: Primary Blue background (10% opacity)
Pressed Reactions: Primary Blue with scale animation
Send Button: Darker Primary Blue
```

#### Loading States
```
Skeleton loaders for forum list
Shimmer effect for messages loading
Spinner for send button
```

### 5. Animations

#### Transitions
```
Page Navigation: Slide transition (300ms ease-out)
Sidebar Toggle: Slide from left (250ms ease-in-out)  
Modal Appearance: Scale + fade (200ms ease-out)
Reaction Add: Scale bounce (150ms ease-out)
```

#### Micro-interactions
```
Button Press: Scale down (100ms)
Message Send: Slide up + fade in (200ms)
New Message: Slide down from top (300ms)
Emoji Reaction: Pop animation (150ms)
```

### 6. Responsive Breakpoints

```
Mobile: < 768px
  - Full-width sidebar overlay
  - Simplified navigation
  - Larger touch targets

Tablet: 768px - 1024px  
  - Collapsible sidebar
  - Optimized spacing
  - Enhanced interactions

Desktop: > 1024px
  - Persistent sidebar
  - Multi-column layout
  - Keyboard shortcuts
```

### 7. Accessibility

#### Focus Indicators
```
Color: Primary Blue
Width: 2px
Style: Solid outline
Offset: 2px
```

#### Screen Reader Labels
```
Forum List: "Forum [name], [unread count] unread messages"
Message: "Message from [author] at [time]: [content preview]"
Reactions: "[emoji] reaction, [count] users reacted"
```

#### Minimum Touch Targets
```
Buttons: 44px x 44px
List Items: 48px minimum height  
Interactive Elements: 32px x 32px minimum
```

### 8. Icon Library

#### Navigation Icons
```
Menu: hamburger (24px)
Back: arrow_back (24px)
Settings: settings (24px)
Search: search (24px)
```

#### Message Icons
```
Send: send (20px)
Emoji: emoji_emotions (20px)
Attach: attach_file (20px)
Reply: reply (16px)
Share: share (16px)
More: more_vert (16px)
```

#### Reaction Icons
```
Like: thumb_up (16px)
Dislike: thumb_down (16px)
Love: favorite (16px)  
Laugh: sentiment_very_satisfied (16px)
```

### 9. Layout Grids

#### Mobile Grid (Portrait)
```
Margins: 16px
Gutters: 8px
Columns: 4
Max Width: 100%
```

#### Tablet Grid  
```
Margins: 24px
Gutters: 16px
Columns: 8
Max Width: 768px
```

#### Desktop Grid
```
Margins: 32px
Gutters: 24px  
Columns: 12
Max Width: 1200px
```

### 10. Component Variants

#### Forum List States
```
Default: Standard appearance
Selected: Primary Blue highlight
Muted: Reduced opacity for archived
Unread: Bold text + badge
```

#### Message States  
```
Own Message: Right-aligned, Primary Blue
Other Message: Left-aligned, Surface color
System Message: Centered, italic text
Pinned Message: Yellow accent border
```

#### Input States
```
Default: Border color
Focused: Primary Blue border  
Error: Error color border
Disabled: Reduced opacity
```

This component library ensures consistent, accessible, and modern design throughout the Telegram-style app.
