import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EmojiReactionsPicker extends StatelessWidget {
  final Function(String) onReactionSelected;
  final List<String> quickReactions;
  
  const EmojiReactionsPicker({
    super.key,
    required this.onReactionSelected,
    this.quickReactions = const ['👍', '👎', '❤️', '😂', '😮', '🔥', '💯', '👏'],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'React with',
            style: AppTextStyles.titleSmall.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Quick Reactions Grid
          Wrap(
            spacing: AppConstants.spacingS,
            runSpacing: AppConstants.spacingS,
            children: quickReactions.map((emoji) => 
              _buildReactionButton(context, emoji),
            ).toList(),
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Custom emoji button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showFullEmojiPicker(context);
              },
              icon: const Icon(Icons.emoji_emotions_outlined),
              label: const Text('More Emojis'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReactionButton(BuildContext context, String emoji) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onReactionSelected(emoji),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
  
  void _showFullEmojiPicker(BuildContext context) {
    // TODO: Implement full emoji picker using emoji_picker_flutter
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Emoji'),
        content: const Text('Full emoji picker coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Reaction display widget for showing existing reactions
class ReactionDisplay extends StatelessWidget {
  final Map<String, int> reactions;
  final Function(String) onReactionTap;
  final String? userReaction;
  
  const ReactionDisplay({
    super.key,
    required this.reactions,
    required this.onReactionTap,
    this.userReaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      spacing: AppConstants.spacingXS,
      runSpacing: AppConstants.spacingXS,
      children: reactions.entries.map((entry) {
        final emoji = entry.key;
        final count = entry.value;
        final isUserReaction = userReaction == emoji;
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onReactionTap(emoji),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isUserReaction 
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(15),
                border: isUserReaction 
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    count.toString(),
                    style: AppTextStyles.reactionCount.copyWith(
                      color: isUserReaction 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isUserReaction 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
