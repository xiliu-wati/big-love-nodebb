import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RichTextEditor extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool showPreview;
  final Function(String)? onChanged;
  
  const RichTextEditor({
    super.key,
    required this.controller,
    this.hintText = 'Enter your content...',
    this.maxLines = 10,
    this.showPreview = true,
    this.onChanged,
  });

  @override
  ConsumerState<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends ConsumerState<RichTextEditor> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPreviewMode = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isPreviewMode = _tabController.index == 1;
      });
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toolbar
          _buildToolbar(theme),
          
          // Tabs (if preview is enabled)
          if (widget.showPreview) _buildTabs(theme),
          
          // Content area
          Container(
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: widget.maxLines * 24.0,
            ),
            child: _isPreviewMode && widget.showPreview
                ? _buildPreview(theme)
                : _buildEditor(theme),
          ),
        ],
      ),
    );
  }
  
  Widget _buildToolbar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusM),
          topRight: Radius.circular(AppConstants.radiusM),
        ),
      ),
      child: Wrap(
        spacing: AppConstants.spacingXS,
        children: [
          _buildToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            onPressed: () => _insertFormatting('**', '**'),
          ),
          _buildToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            onPressed: () => _insertFormatting('*', '*'),
          ),
          _buildToolbarButton(
            icon: Icons.format_strikethrough,
            tooltip: 'Strikethrough',
            onPressed: () => _insertFormatting('~~', '~~'),
          ),
          _buildToolbarButton(
            icon: Icons.code,
            tooltip: 'Inline Code',
            onPressed: () => _insertFormatting('`', '`'),
          ),
          _buildToolbarButton(
            icon: Icons.code_outlined,
            tooltip: 'Code Block',
            onPressed: () => _insertCodeBlock(),
          ),
          _buildToolbarButton(
            icon: Icons.format_quote,
            tooltip: 'Quote',
            onPressed: () => _insertQuote(),
          ),
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet List',
            onPressed: () => _insertList('- '),
          ),
          _buildToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered List',
            onPressed: () => _insertList('1. '),
          ),
          _buildToolbarButton(
            icon: Icons.link,
            tooltip: 'Link',
            onPressed: () => _insertLink(),
          ),
          _buildToolbarButton(
            icon: Icons.tag,
            tooltip: 'Hashtag',
            onPressed: () => _insertText('#'),
          ),
          _buildToolbarButton(
            icon: Icons.alternate_email,
            tooltip: 'Mention',
            onPressed: () => _insertText('@'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTabs(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Write'),
          Tab(text: 'Preview'),
        ],
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }
  
  Widget _buildEditor(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        style: AppTextStyles.bodyMedium,
        maxLines: null,
        onChanged: widget.onChanged,
      ),
    );
  }
  
  Widget _buildPreview(ThemeData theme) {
    final content = widget.controller.text;
    
    if (content.trim().isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Center(
          child: Text(
            'Nothing to preview',
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: MarkdownPreview(content: content),
    );
  }
  
  void _insertFormatting(String before, String after) {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    
    if (selection.isValid) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.substring(0, selection.start) +
          before + selectedText + after +
          text.substring(selection.end);
      
      widget.controller.text = newText;
      widget.controller.selection = TextSelection.collapsed(
        offset: selection.start + before.length + selectedText.length + after.length,
      );
    } else {
      final cursorPos = selection.base.offset;
      final newText = text.substring(0, cursorPos) +
          before + after +
          text.substring(cursorPos);
      
      widget.controller.text = newText;
      widget.controller.selection = TextSelection.collapsed(
        offset: cursorPos + before.length,
      );
    }
    
    widget.onChanged?.call(widget.controller.text);
  }
  
  void _insertText(String textToInsert) {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final cursorPos = selection.base.offset;
    
    final newText = text.substring(0, cursorPos) +
        textToInsert +
        text.substring(cursorPos);
    
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: cursorPos + textToInsert.length,
    );
    
    widget.onChanged?.call(widget.controller.text);
  }
  
  void _insertCodeBlock() {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final cursorPos = selection.base.offset;
    
    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1) + 1;
    if (lineStart < 0) lineStart = 0;
    
    final beforeText = text.substring(0, lineStart);
    final afterText = text.substring(cursorPos);
    
    final codeBlock = '```\n\n```\n';
    final newText = beforeText + codeBlock + afterText;
    
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: beforeText.length + 4, // Position cursor inside code block
    );
    
    widget.onChanged?.call(widget.controller.text);
  }
  
  void _insertQuote() {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final cursorPos = selection.base.offset;
    
    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1) + 1;
    if (lineStart < 0) lineStart = 0;
    
    final newText = text.substring(0, lineStart) +
        '> ' +
        text.substring(lineStart);
    
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: cursorPos + 2,
    );
    
    widget.onChanged?.call(widget.controller.text);
  }
  
  void _insertList(String prefix) {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final cursorPos = selection.base.offset;
    
    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1) + 1;
    if (lineStart < 0) lineStart = 0;
    
    final newText = text.substring(0, lineStart) +
        prefix +
        text.substring(lineStart);
    
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: cursorPos + prefix.length,
    );
    
    widget.onChanged?.call(widget.controller.text);
  }
  
  void _insertLink() {
    showDialog(
      context: context,
      builder: (context) => _LinkDialog(
        onLinkInserted: (title, url) {
          final linkText = '[$title]($url)';
          _insertText(linkText);
        },
      ),
    );
  }
}

// Link insertion dialog
class _LinkDialog extends StatefulWidget {
  final Function(String title, String url) onLinkInserted;
  
  const _LinkDialog({required this.onLinkInserted});

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  
  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Link'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Link Text',
              hintText: 'Enter the link text',
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://example.com',
            ),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _urlController.text.isNotEmpty) {
              widget.onLinkInserted(_titleController.text, _urlController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}

// Markdown preview widget
class MarkdownPreview extends StatelessWidget {
  final String content;
  
  const MarkdownPreview({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    try {
      final html = md.markdownToHtml(
        content,
        extensionSet: md.ExtensionSet.gitHubFlavored,
      );
      
      return SelectableText.rich(
        _parseMarkdown(content, theme),
        style: AppTextStyles.bodyMedium.copyWith(
          height: 1.6,
        ),
      );
    } catch (e) {
      return Text(
        content,
        style: AppTextStyles.bodyMedium.copyWith(
          height: 1.6,
        ),
      );
    }
  }
  
  TextSpan _parseMarkdown(String text, ThemeData theme) {
    final spans = <TextSpan>[];
    final lines = text.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (line.startsWith('# ')) {
        // Heading 1
        spans.add(TextSpan(
          text: '${line.substring(2)}\n',
          style: AppTextStyles.headlineLarge.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (line.startsWith('## ')) {
        // Heading 2
        spans.add(TextSpan(
          text: '${line.substring(3)}\n',
          style: AppTextStyles.headlineMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (line.startsWith('### ')) {
        // Heading 3
        spans.add(TextSpan(
          text: '${line.substring(4)}\n',
          style: AppTextStyles.headlineSmall.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (line.startsWith('> ')) {
        // Quote
        spans.add(TextSpan(
          text: '${line.substring(2)}\n',
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
            backgroundColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
          ),
        ));
      } else if (line.startsWith('```')) {
        // Code block - find the end
        final codeLines = <String>[];
        int j = i + 1;
        while (j < lines.length && !lines[j].startsWith('```')) {
          codeLines.add(lines[j]);
          j++;
        }
        
        spans.add(TextSpan(
          text: '${codeLines.join('\n')}\n',
          style: AppTextStyles.codeBlock.copyWith(
            color: theme.colorScheme.onSurface,
            backgroundColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
          ),
        ));
        
        i = j; // Skip to end of code block
      } else {
        // Regular text with inline formatting
        spans.add(_parseInlineFormatting(line + '\n', theme));
      }
    }
    
    return TextSpan(children: spans);
  }
  
  TextSpan _parseInlineFormatting(String text, ThemeData theme) {
    final spans = <TextSpan>[];
    
    // Simple regex patterns for inline formatting
    final patterns = {
      RegExp(r'\*\*(.*?)\*\*'): (String match) => TextSpan(
        text: match,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
      ),
      RegExp(r'\*(.*?)\*'): (String match) => TextSpan(
        text: match,
        style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
      ),
      RegExp(r'`(.*?)`'): (String match) => TextSpan(
        text: match,
        style: AppTextStyles.code.copyWith(
          backgroundColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        ),
      ),
      RegExp(r'#(\w+)'): (String match) => TextSpan(
        text: match,
        style: AppTextStyles.bodyMedium.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      RegExp(r'@(\w+)'): (String match) => TextSpan(
        text: match,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    };
    
    // For now, just return the text as-is
    // TODO: Implement proper inline markdown parsing
    return TextSpan(
      text: text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
