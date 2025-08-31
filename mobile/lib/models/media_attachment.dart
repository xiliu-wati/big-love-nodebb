import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_attachment.g.dart';

enum AttachmentType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('document')
  document,
  @JsonValue('link')
  link
}

@JsonSerializable()
class MediaAttachment extends Equatable {
  final int id;
  final String filename;
  final String url;
  final String? thumbnailUrl;
  final AttachmentType type;
  final int size;
  final String mimeType;
  final Map<String, dynamic>? metadata;

  const MediaAttachment({
    required this.id,
    required this.filename,
    required this.url,
    this.thumbnailUrl,
    required this.type,
    required this.size,
    required this.mimeType,
    this.metadata,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) => _$MediaAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);

  String get displaySize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  bool get isImage => type == AttachmentType.image;
  bool get isVideo => type == AttachmentType.video;
  bool get isAudio => type == AttachmentType.audio;
  bool get isDocument => type == AttachmentType.document;
  bool get isLink => type == AttachmentType.link;

  String get typeDisplayName {
    switch (type) {
      case AttachmentType.image:
        return 'Image';
      case AttachmentType.video:
        return 'Video';
      case AttachmentType.audio:
        return 'Audio';
      case AttachmentType.document:
        return 'Document';
      case AttachmentType.link:
        return 'Link';
    }
  }

  MediaAttachment copyWith({
    int? id,
    String? filename,
    String? url,
    String? thumbnailUrl,
    AttachmentType? type,
    int? size,
    String? mimeType,
    Map<String, dynamic>? metadata,
  }) {
    return MediaAttachment(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [id, filename, url, thumbnailUrl, type, size, mimeType, metadata];
}
