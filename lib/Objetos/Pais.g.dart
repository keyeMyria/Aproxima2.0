// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Pais.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pais _$PaisFromJson(Map<String, dynamic> json) {
  return Pais(
      json['id_pais'] == null ||
              json['id_pais'].toString().replaceAll(' ', '') == ''
          ? null
          : int.parse(json['id_pais'].toString()),
      json['pais'] as String,
      json['sigla'] as String);
}

Map<String, dynamic> _$PaisToJson(Pais instance) => <String, dynamic>{
      'id_pais': instance.id_pais,
      'pais': instance.pais,
      'sigla': instance.sigla
    };
