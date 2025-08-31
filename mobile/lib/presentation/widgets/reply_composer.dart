import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/post.dart';
import '../providers/forum_provider.dart';

class ReplyComposer extends ConsumerStatefulWidget {
  final Post replyingTo;
  final Function(String) onSubmit;
  final VoidCallback onCancel;
  
  const ReplyComposer({
    super.key,
    required this.replyingTo,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  ConsumerState<ReplyComposer> createState() => _ReplyComposerState();
}

class _ReplyComposerState extends ConsumerState<ReplyComposer>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Auto-focus and expand
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _expandComposer();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              top: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reply context
                  if (_isExpanded) ...[
                    _buildReplyContext(),
                    const SizedBox(height: AppConstants.spacingM),
                  ],
                  
                  // User info and input
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User avatar
                      Container(
                        width: AppConstants.avatarM,
                        height: AppConstants.avatarM,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentUser != null
                              ? AppColors.getRoleColor(currentUser.role.name, isVip: currentUser.isVip)
                                  .withValues(alpha: 0.2)
                              : Colors.grey[300],
                        ),
                        child: currentUser?.avatarUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  currentUser!.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => 
                                      _buildAvatarFallback(currentUser),
                                ),
                              )
                            : _buildAvatarFallback(currentUser),
                      ),
                      
                      const SizedBox(width: AppConstants.spacingM),
                      
                      // Input area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Input field
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: _getHintText(),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppConstants.spacingM,
                                    vertical: AppConstants.spacingS,
                                  ),
                                ),
                                maxLines: _isExpanded ? 5 : 1,
                                minLines: 1,
                                textInputAction: TextInputAction.newline,
                                onChanged: _handleTextChanged,
                              ),
                            ),
                            
                            // Action buttons
                            SizeTransition(
                              sizeFactor: _animation,
                              child: Container(
                                margin: const EdgeInsets.only(top: AppConstants.spacingS),
                                child: Row(
                                  children: [
                                    // Formatting options
                                    IconButton(
                                      onPressed: () => _insertText('**', '**'),
                                      icon: const Icon(Icons.format_bold, size: 20),
                                      tooltip: 'Bold',
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    IconButton(
                                      onPressed: () => _insertText('*', '*'),
                                      icon: const Icon(Icons.format_italic, size: 20),
                                      tooltip: 'Italic',
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    IconButton(
                                      onPressed: () => _insertText('`', '`'),
                                      icon: const Icon(Icons.code, size: 20),
                                      tooltip: 'Code',
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    IconButton(
                                      onPressed: _insertQuote,
                                      icon: const Icon(Icons.format_quote, size: 20),
                                      tooltip: 'Quote',
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    
                                    const Spacer(),
                                    
                                    // Action buttons
                                    TextButton(
                                      onPressed: widget.onCancel,
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: AppConstants.spacingS),
                                    ElevatedButton(
                                      onPressed: _canSubmit() ? _submitReply : null,
                                      child: const Text('Reply'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildReplyContext() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Replying to ${widget.replyingTo.author.name}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onCancel,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            widget.replyingTo.content,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAvatarFallback(dynamic user) {
    if (user == null) {
      return const Icon(Icons.person, color: Colors.grey);
    }
    
    return Center(
      child: Text(
        user.name[0].toUpperCase(),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  String _getHintText() {
    if (widget.replyingTo.id == 0) {
      return 'Reply to this post...';
    }
    return 'Reply to ${widget.replyingTo.author.name}...';
  }
  
  void _expandComposer() {
    setState(() {
      _isExpanded = true;
    });
    _animationController.forward();
  }
  
  void _handleTextChanged(String text) {
    if (!_isExpanded && text.isNotEmpty) {
      _expandComposer();
    }
  }
  
  void _insertText(String before, String after) {
    final selection = _controller.selection;
    if (selection.isValid) {
      final text = _controller.text;
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.substring(0, selection.start) +
          before + selectedText + after +
          text.substring(selection.end);
      
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(
        offset: selection.start + before.length + selectedText.length + after.length,
      );
    } else {
      final cursorPos = _controller.selection.base.offset;
      final text = _controller.text;
      final newText = text.substring(0, cursorPos) +
          before + after +
          text.substring(cursorPos);
      
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(
        offset: cursorPos + before.length,
      );
    }
    _focusNode.requestFocus();
  }
  
  void _insertQuote() {
    final text = _controller.text;
    final cursorPos = _controller.selection.base.offset;
    
    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1) + 1;
    if (lineStart < 0) lineStart = 0;
    
    final newText = text.substring(0, lineStart) +
        '> ' +
        text.substring(lineStart);
    
    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(
      offset: cursorPos + 2,
    );
    _focusNode.requestFocus();
  }
  
  bool _canSubmit() {
    return _controller.text.trim().isNotEmpty;
  }
  
  void _submitReply() {
    if (_canSubmit()) {
      widget.onSubmit(_controller.text.trim());
    }
  }
}
