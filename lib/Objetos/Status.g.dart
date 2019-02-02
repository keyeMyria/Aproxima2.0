// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) {
  return Status(int.parse(json['idStatus']), json['descricao'] as String);
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'idStatus': instance.idStatus,
      'descricao': instance.descricao
    };
