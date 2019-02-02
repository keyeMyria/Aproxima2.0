// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Protocolo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Protocolo _$ProtocoloFromJson(Map<String, dynamic> json) {
  return Protocolo(
      int.parse(json['id']),
      double.parse(json['lat']),
      double.parse(json['lng']),
      json['titulo'] as String,
      json['descricao'] as String,
      int.parse(json['id_status']),
      int.parse(json['user_id']),
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      json['cidade_id'] == null ||
              json['cidade_id'].toString().replaceAll(' ', '') == ''
          ? null
          : int.parse(json['cidade_id']),
      json['secretaria_id'] == null ||
              json['secretaria_id'].toString().replaceAll(' ', '') == ''
          ? null
          : int.parse(json['secretaria_id']),
      json['endereco'] as String,
      json['bairro'] as String,
      json['permissao'] == null ||
              json['permissao'].toString().replaceAll(' ', '') == ''
          ? null
          : int.parse(json['permissao']),
      json['prioridade'] != null ? int.parse(json['prioridade']) : 0,
      json['anonimo'] as String,
      json['cidade'] == null
          ? null
          : Cidade.fromJson(json['cidade'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      json['secretaria'] == null
          ? null
          : Secretaria.fromJson(json['secretaria'] as Map<String, dynamic>),
      (json['tags'] as List)
          ?.map((e) =>
              e == null ? null : Tagss.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['fotos'] as List)
          ?.map((e) =>
              e == null ? null : Foto.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['updates_protocolos'] as List)
          ?.map((e) => e == null
              ? null
              : UpdateProtocolo.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['inserted'] as bool);
}

Map<String, dynamic> _$ProtocoloToJson(Protocolo instance) => <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'id_status': instance.id_status,
      'user_id': instance.user_id,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'cidade_id': instance.cidade_id,
      'secretaria_id': instance.secretaria_id,
      'endereco': instance.endereco,
      'bairro': instance.bairro,
      'permissao': instance.permissao,
      'prioridade': instance.prioridade,
      'anonimo': instance.anonimo,
      'cidade': instance.cidade,
      'usuario': instance.usuario,
      'status': instance.status,
      'secretaria': instance.secretaria,
      'tags': instance.tags,
      'fotos': instance.fotos,
      'updates_protocolos': instance.updates_protocolos,
      'inserted': instance.inserted
    };
