import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/media_attachment.dart';

class MediaPicker extends ConsumerStatefulWidget {
  final Function(List<MediaAttachment>) onMediaSelected;
  final int maxFiles;
  final List<String> allowedTypes;
  
  const MediaPicker({
    super.key,
    required this.onMediaSelected,
    this.maxFiles = 5,
    this.allowedTypes = const ['image', 'video', 'document'],
  });

  @override
  ConsumerState<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends ConsumerState<MediaPicker> {
  final List<MediaAttachment> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Add Media',
                style: AppTextStyles.titleSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (_selectedMedia.isNotEmpty)
                TextButton(
                  onPressed: _clearSelection,
                  child: const Text('Clear All'),
                ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Media options
          Wrap(
            spacing: AppConstants.spacingS,
            runSpacing: AppConstants.spacingS,
            children: [
              if (widget.allowedTypes.contains('image'))
                _buildMediaButton(
                  icon: Icons.image,
                  label: 'Photos',
                  color: Colors.blue,
                  onPressed: _pickImages,
                ),
              if (widget.allowedTypes.contains('image'))
                _buildMediaButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.green,
                  onPressed: _takePicture,
                ),
              if (widget.allowedTypes.contains('video'))
                _buildMediaButton(
                  icon: Icons.videocam,
                  label: 'Video',
                  color: Colors.purple,
                  onPressed: _pickVideo,
                ),
              if (widget.allowedTypes.contains('document'))
                _buildMediaButton(
                  icon: Icons.attach_file,
                  label: 'Files',
                  color: Colors.orange,
                  onPressed: _pickFiles,
                ),
            ],
          ),
          
          // Selected media preview
          if (_selectedMedia.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingM),
            _buildMediaPreview(),
          ],
        ],
      ),
    );
  }
  
  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: _selectedMedia.length < widget.maxFiles ? onPressed : null,
      icon: Icon(icon, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.5)),
      ),
    );
  }
  
  Widget _buildMediaPreview() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedMedia.length,
        itemBuilder: (context, index) {
          final media = _selectedMedia[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: AppConstants.spacingS),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: _buildMediaPreviewItem(media),
                ),
                
                // Remove button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeMedia(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // File info
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppConstants.radiusS),
                        bottomRight: Radius.circular(AppConstants.radiusS),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          media.filename,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          media.displaySize,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMediaPreviewItem(MediaAttachment media) {
    switch (media.type) {
      case AttachmentType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
          child: Image.network(
            media.url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          ),
        );
      case AttachmentType.video:
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 32,
              color: Colors.blue,
            ),
          ),
        );
      case AttachmentType.document:
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          child: const Center(
            child: Icon(
              Icons.description,
              size: 32,
              color: Colors.orange,
            ),
          ),
        );
      default:
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          child: const Center(
            child: Icon(
              Icons.attachment,
              size: 32,
              color: Colors.grey,
            ),
          ),
        );
    }
  }
  
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      
      for (final image in images) {
        if (_selectedMedia.length >= widget.maxFiles) break;
        
        final file = File(image.path);
        final size = await file.length();
        
        if (size > AppConstants.maxImageSizeMB * 1024 * 1024) {
          if (mounted) {
            _showSizeError('Image file is too large (max ${AppConstants.maxImageSizeMB}MB)');
          }
          continue;
        }
        
        final attachment = MediaAttachment(
          id: DateTime.now().millisecondsSinceEpoch + _selectedMedia.length,
          filename: image.name,
          url: image.path,
          type: AttachmentType.image,
          size: size,
          mimeType: 'image/${image.path.split('.').last}',
        );
        
        _selectedMedia.add(attachment);
      }
      
      _updateParent();
    } catch (e) {
      if (mounted) {
        _showError('Failed to pick images: $e');
      }
    }
  }
  
  Future<void> _takePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) return;
      
      final file = File(image.path);
      final size = await file.length();
      
      if (size > AppConstants.maxImageSizeMB * 1024 * 1024) {
        if (mounted) {
          _showSizeError('Image file is too large (max ${AppConstants.maxImageSizeMB}MB)');
        }
        return;
      }
      
      final attachment = MediaAttachment(
        id: DateTime.now().millisecondsSinceEpoch,
        filename: image.name,
        url: image.path,
        type: AttachmentType.image,
        size: size,
        mimeType: 'image/${image.path.split('.').last}',
      );
      
      setState(() {
        _selectedMedia.add(attachment);
      });
      
      _updateParent();
    } catch (e) {
      if (mounted) {
        _showError('Failed to take picture: $e');
      }
    }
  }
  
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (video == null) return;
      
      final file = File(video.path);
      final size = await file.length();
      
      if (size > AppConstants.maxFileSizeMB * 1024 * 1024) {
        if (mounted) {
          _showSizeError('Video file is too large (max ${AppConstants.maxFileSizeMB}MB)');
        }
        return;
      }
      
      final attachment = MediaAttachment(
        id: DateTime.now().millisecondsSinceEpoch,
        filename: video.name,
        url: video.path,
        type: AttachmentType.video,
        size: size,
        mimeType: 'video/${video.path.split('.').last}',
      );
      
      setState(() {
        _selectedMedia.add(attachment);
      });
      
      _updateParent();
    } catch (e) {
      if (mounted) {
        _showError('Failed to pick video: $e');
      }
    }
  }
  
  Future<void> _pickFiles() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      
      if (result != null) {
        for (final file in result.files) {
          if (_selectedMedia.length >= widget.maxFiles) break;
          
          if (file.size > AppConstants.maxFileSizeMB * 1024 * 1024) {
            if (mounted) {
              _showSizeError('${file.name} is too large (max ${AppConstants.maxFileSizeMB}MB)');
            }
            continue;
          }
          
          final attachment = MediaAttachment(
            id: DateTime.now().millisecondsSinceEpoch + _selectedMedia.length,
            filename: file.name,
            url: file.path!,
            type: AttachmentType.document,
            size: file.size,
            mimeType: file.extension != null ? 'application/${file.extension}' : 'application/octet-stream',
          );
          
          _selectedMedia.add(attachment);
        }
        
        _updateParent();
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to pick files: $e');
      }
    }
  }
  
  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
    _updateParent();
  }
  
  void _clearSelection() {
    setState(() {
      _selectedMedia.clear();
    });
    _updateParent();
  }
  
  void _updateParent() {
    setState(() {});
    widget.onMediaSelected(_selectedMedia);
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  void _showSizeError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Too Large'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Media Gallery Widget for displaying attachments
class MediaGallery extends StatefulWidget {
  final List<MediaAttachment> attachments;
  final bool allowFullScreen;
  
  const MediaGallery({
    super.key,
    required this.attachments,
    this.allowFullScreen = true,
  });

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) return const SizedBox.shrink();
    
    if (widget.attachments.length == 1) {
      return _buildSingleMedia(widget.attachments.first);
    }
    
    return _buildMultipleMedia();
  }
  
  Widget _buildSingleMedia(MediaAttachment attachment) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: _buildMediaItem(attachment, isLarge: true),
      ),
    );
  }
  
  Widget _buildMultipleMedia() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.attachments.length,
        itemBuilder: (context, index) {
          final attachment = widget.attachments[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: AppConstants.spacingS),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
              child: _buildMediaItem(attachment),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMediaItem(MediaAttachment attachment, {bool isLarge = false}) {
    return GestureDetector(
      onTap: widget.allowFullScreen ? () => _showFullScreen(attachment) : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildMediaContent(attachment),
          
          // Media type indicator
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getMediaIcon(attachment.type),
                    size: 12,
                    color: Colors.white,
                  ),
                  if (!isLarge) ...[
                    const SizedBox(width: 4),
                    Text(
                      attachment.typeDisplayName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMediaContent(MediaAttachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return Image.network(
          attachment.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 32),
            ),
          ),
        );
      case AttachmentType.video:
        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Container(
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getMediaIcon(attachment.type),
                size: 32,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  attachment.filename,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                attachment.displaySize,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
    }
  }
  
  IconData _getMediaIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.video:
        return Icons.play_circle_outline;
      case AttachmentType.audio:
        return Icons.audiotrack;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.link:
        return Icons.link;
    }
  }
  
  void _showFullScreen(MediaAttachment attachment) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: _buildFullScreenContent(attachment),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFullScreenContent(MediaAttachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.1,
          maxScale: 4,
          child: Image.network(
            attachment.url,
            fit: BoxFit.contain,
          ),
        );
      case AttachmentType.video:
        return Container(
          color: Colors.black,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 64,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Video playback coming soon',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      default:
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getMediaIcon(attachment.type),
                size: 64,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                attachment.filename,
                style: AppTextStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${attachment.displaySize} • ${attachment.typeDisplayName}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement file download/open
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.download),
                label: const Text('Download'),
              ),
            ],
          ),
        );
    }
  }
}
