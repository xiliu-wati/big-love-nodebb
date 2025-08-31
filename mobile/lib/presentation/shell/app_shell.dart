import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/chinese_strings.dart';
import '../../core/theme/app_colors.dart';
import '../providers/forum_provider.dart';
import 'sidebar/app_sidebar.dart';
import 'main_content/main_content_area.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with TickerProviderStateMixin {
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarAnimation;
  bool _isSidebarOpen = false;
  
  @override
  void initState() {
    super.initState();
    _sidebarAnimationController = AnimationController(
      vsync: this,
      duration: AppConstants.animationMedium,
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    );
    
    // Auto-select first forum when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectFirstForumIfNone();
    });
  }
  
  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  void _selectFirstForumIfNone() {
    final forumsAsync = ref.read(forumsProvider);
    final currentSelection = ref.read(selectedForumProvider);
    
    forumsAsync.whenData((forums) {
      if (currentSelection == null && forums.isNotEmpty) {
        ref.read(selectedForumProvider.notifier).state = forums.first;
      }
    });
  }
  
  bool get isTablet => MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;
  bool get isDesktop => MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  bool get isMobile => !isTablet && !isDesktop;
  
  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _sidebarAnimationController.forward();
      } else {
        _sidebarAnimationController.reverse();
      }
    });
  }
  
  void _closeSidebar() {
    if (_isSidebarOpen) {
      setState(() {
        _isSidebarOpen = false;
        _sidebarAnimationController.reverse();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: isMobile ? AppBar(
        title: Text(ChineseStrings.appFullName),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _toggleSidebar,
        ),
      ) : null,
      body: Row(
        children: [
          // Sidebar - always visible on desktop, overlay on mobile/tablet
          if (isDesktop) ...[
            // Desktop: Persistent sidebar
            SizedBox(
              width: AppConstants.sidebarWidth,
              child: AppSidebar(
                isCompact: false,
                onForumSelected: (forum) {
                  // Forum selected on desktop
                },
              ),
            ),
            // Sidebar separator
            Container(
              width: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ] else if (isTablet) ...[
            // Tablet: Collapsible sidebar
            AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: _sidebarAnimation.value * AppConstants.sidebarWidthCompact,
                  child: AppSidebar(
                    isCompact: true,
                    onForumSelected: (forum) => _closeSidebar(),
                  ),
                );
              },
            ),
          ],
          
          // Main content area
          Expanded(
            child: Stack(
              children: [
                // Main content  
                MainContentArea(child: widget.child),
                
                // Mobile sidebar overlay
                if (isMobile && _isSidebarOpen) ...[
                  // Background overlay
                  GestureDetector(
                    onTap: _closeSidebar,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                  // Sidebar
                  AnimatedBuilder(
                    animation: _sidebarAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          -AppConstants.sidebarWidth * (1 - _sidebarAnimation.value),
                          0,
                        ),
                        child: SizedBox(
                          width: AppConstants.sidebarWidth,
                          child: AppSidebar(
                            isCompact: false,
                            onForumSelected: (forum) {
                              _closeSidebar();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}