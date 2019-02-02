// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cidade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CidadeFromServer(json) {
  return Cidade(
      json['cidade'] as String,
      json['id_cidade'] == null
          ? int.parse(json['idCidade'])
          : int.parse(json['id_cidade'].toString()),
      int.parse(json['fk_estado'].toString()),
      double.parse(json['lat'].toString()),
      double.parse(json['lng'].toString()),
      json['estado'] == null ? null : Estado.fromServer(json['estado']));
}

Cidade _$CidadeFromJson(Map<String, dynamic> json) {
  return Cidade(
      json['cidade'] as String,
      json['id_cidade'] == null
          ? int.parse(json['idCidade'])
          : int.parse(json['id_cidade'].toString()),
      int.parse(json['fk_estado'].toString()),
      double.parse(json['lat'].toString()),
      double.parse(json['lng'].toString()),
      json['estado'] == null
          ? null
          : Estado.fromJson(json['estado'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CidadeToJson(Cidade instance) => <String, dynamic>{
      'cidade': instance.cidade,
      'id_cidade': instance.id_cidade,
      'fk_estado': instance.fk_estado,
      'lat': instance.lat,
      'lng': instance.lng,
      'estado': instance.estado.toJson()
    };
