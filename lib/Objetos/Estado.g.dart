// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Estado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
_$EstadoFromServer(json) {
  return Estado(
      (json['estado'] == null ? json['Estado'] : json['estado']) as String,
      json['idEstado'] == null
          ? int.parse(json['id_estado'].toString())
          : int.parse(json['idEstado'].toString()),
      (json['sigla'] == null ? json['Sigla'] : json['sigla']) as String,
      int.parse(json['fk_pais'].toString()),
      json['pais'] == null
          ? json['Pais'] == null ? null : new Pais.fromJson(json['Pais'])
          : Pais.fromJson(json['pais'] as Map<String, dynamic>));
}

Estado _$EstadoFromJson(Map<String, dynamic> json) {
  return Estado(
      (json['estado'] == null ? json['Estado'] : json['estado']) as String,
      json['idEstado'] == null
          ? int.parse(json['id_estado'].toString())
          : int.parse(json['idEstado'].toString()),
      (json['sigla'] == null ? json['Sigla'] : json['sigla']) as String,
      int.parse(json['fk_pais'].toString()),
      json['pais'] == null
          ? json['Pais'] == null ? null : new Pais.fromJson(json['Pais'])
          : Pais.fromJson(json['pais'] as Map<String, dynamic>));
}

Map<String, dynamic> _$EstadoToJson(Estado instance) => <String, dynamic>{
      'estado': instance.estado,
      'id_estado': instance.id_estado,
      'sigla': instance.sigla,
      'fk_pais': instance.fk_pais,
      'pais': instance.pais.toJson()
    };
