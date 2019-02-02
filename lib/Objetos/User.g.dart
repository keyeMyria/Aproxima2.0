// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFromServer(json) {
  return User(
      int.parse(json['id'].toString()),
      (json['nome'] as String),
      json['email'] as String,
      json['senhaSite'] as String,
      json['senhaApp'] as String,
      json['telefone'] as String,
      json['endereco'] as String,
      json['dataNascimento'] == null
          ? null
          : DateTime.parse(json['dataNascimento'] as String),
      int.parse(json['id_cidade'].toString()),
      json['permissao'] != null ? int.parse(json['permissao'].toString()) : 0,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      json['firebasekey'] as String,
      json['cidade'] == null ? null : Cidade.fromServer(json['cidade']),
      json['secretaria_id'] == null ||
              json['secretaria_id'].toString().replaceAll(' ', '') == ''
          ? null
          : int.parse(json['secretaria_id']));
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      int.parse(json['id'].toString()),
      (json['nome'] as String),
      json['email'] as String,
      json['senha_site'] as String,
      json['senha_app'] as String,
      json['telefone'] as String,
      json['endereco'] as String,
      json['dataNascimento'] == null
          ? null
          : DateTime.parse(json['dataNascimento'] as String),
      int.parse(json['id_cidade'].toString()),
      json['permissao'] != null ? int.parse(json['permissao'].toString()) : 0,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      json['firebasekey'] as String,
      json['cidade'] == null
          ? null
          : Cidade.fromJson(json['cidade'] as Map<String, dynamic>),
      json['secretaria_id'] == null ||
              json['secretaria_id'].toString().replaceAll(' ', '') == ''
          ? null
          : int.parse(json['secretaria_id']));
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'email': instance.email,
      'senhaSite': instance.senhaSite,
      'senhaApp': instance.senhaApp,
      'telefone': instance.telefone,
      'endereco': instance.endereco,
      'dataNascimento': instance.dataNascimento?.toIso8601String(),
      'idCidade': instance.idCidade,
      'id_cidade': instance.idCidade,
      'permissao': instance.permissao,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'firebasekey': instance.firebasekey,
      'cidade': instance.cidade.toJson(),
      'SecretariaId': instance.secretariaId
    };
