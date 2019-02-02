// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateProtocolo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateTime Formatar(String s) {
  try {
    var d = s.split('-');
    var c = d[2].split(' ');
    var j = c[1].split(':');
    print(
        '${int.parse(d[0])} ${int.parse(d[1])} ${int.parse(c[0])} ${int.parse(j[0])} ${int.parse(j[1])}');
    print(
        'AQUI FDP  D ${d.toString()}   + C  ${c.toString()}   + J ${j.toString()}');
    DateTime date = new DateTime(int.parse(d[0]), int.parse(d[1]),
        int.parse(c[0]), int.parse(j[0]), int.parse(j[1]));
    return date;
  } catch (err) {
    print('ERRO : ${err.toString()}');
    return null;
  }
}

UpdateProtocolo _$UpdateProtocoloFromJson(Map<String, dynamic> json) {
  print('AQUI LOLOLOL ${json['created_at']}');
  return UpdateProtocolo(
      int.parse(json['id']),
      int.parse(json['user_id']),
      json['descricao'] as String,
      json['titulo'] as String,
      json['created_at'] == null
          ? null
          : Formatar(json['created_at'].toString()),
      json['updated_at'] == null
          ? null
          : Formatar(json['updated_at'].toString()),
      json['deleted_at'] == null
          ? null
          : Formatar(json['deleted_at'].toString()),
      json['display_name'] as String,
      json['anonimo'] as String,
      json['id_protocolo'] as String,
      json['id_status'] as String,
      json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UpdateProtocoloToJson(UpdateProtocolo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'descricao': instance.descricao,
      'titulo': instance.titulo,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'deleted_at': instance.deleted_at,
      'display_name': instance.display_name,
      'anonimo': instance.anonimo,
      'id_protocolo': instance.id_protocolo,
      'id_status': instance.id_status,
      'status': instance.status,
      'user': instance.user
    };
