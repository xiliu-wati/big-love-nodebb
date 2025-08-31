// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaAttachment _$MediaAttachmentFromJson(Map<String, dynamic> json) =>
    MediaAttachment(
      id: (json['id'] as num).toInt(),
      filename: json['filename'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
      size: (json['size'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MediaAttachmentToJson(MediaAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': _$AttachmentTypeEnumMap[instance.type]!,
      'size': instance.size,
      'mimeType': instance.mimeType,
      'metadata': instance.metadata,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.image: 'image',
  AttachmentType.video: 'video',
  AttachmentType.audio: 'audio',
  AttachmentType.document: 'document',
  AttachmentType.link: 'link',
};
