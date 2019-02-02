// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Oficio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Oficio _$OficioFromJson(Map<String, dynamic> json) {
  return Oficio(
      json['Updated_at'] as String,
      json['Created_at'] as String,
      json['Link'] as String,
      json['User_id'] as String,
      json['Texto'] as String,
      json['Secretaria_id'] as String,
      json['Cidade_id'] as String,
      json['Id'] as String,
      json['Deleted_at'] as String);
}

Map<String, dynamic> _$OficioToJson(Oficio instance) => <String, dynamic>{
      'Updated_at': instance.Updated_at,
      'Created_at': instance.Created_at,
      'Link': instance.Link,
      'User_id': instance.User_id,
      'Texto': instance.Texto,
      'Secretaria_id': instance.Secretaria_id,
      'Cidade_id': instance.Cidade_id,
      'Id': instance.Id,
      'Deleted_at': instance.Deleted_at
    };
