// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(
      int.parse(json['id']),
      json['tag_nome'] as String,
      json['created_at'] == null ||
              json['created_at'].toString().replaceAll(' ', '') == ''
          ? null
          : DateTime.parse(json['created_at']),
      json['updated_at'] == null ||
              json['updated_at'].toString().replaceAll(' ', '') == ''
          ? null
          : DateTime.parse(json['updated_at']),
      json['deleted_at'] == null ||
              json['deleted_at'].toString().replaceAll(' ', '') == ''
          ? null
          : DateTime.parse(json['deleted_at']),
      json['idLocal'] as int);
}

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'tag_nome': instance.tag_nome,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'idLocal': instance.idLocal
    };
