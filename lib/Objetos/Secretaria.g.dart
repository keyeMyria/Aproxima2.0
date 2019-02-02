// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Secretaria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secretaria _$SecretariaFromJson(Map<String, dynamic> json) {
  return json['id'] == null
      ? null
      : Secretaria(
          int.parse(json['id']),
          json['nome'] as String,
          int.parse(json['cidade_id']),
          int.parse(json['permissao']),
          json['cidade'] == null
              ? null
              : Cidade.fromJson(json['cidade'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SecretariaToJson(Secretaria instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'cidade_id': instance.cidade_id,
      'permissao': instance.permissao,
      'cidade': instance.cidade
    };
