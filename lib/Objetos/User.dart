import 'package:aproxima/Objetos/Cidade.dart';
import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  int id;
  String nome;
  String email;
  String senhaSite;
  String senhaApp;
  String telefone;
  String endereco;
  DateTime dataNascimento;
  int idCidade;
  int permissao;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime deletedAt;
  String firebasekey;
  Cidade cidade;
  int secretariaId;

  String foto;

  User.Empty();
  toJson() {
    return _$UserToJson(this);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  factory User.fromServer(json) => _$UserFromServer(json);
  User.withFoto(
      this.id,
      this.nome,
      this.email,
      this.senhaSite,
      this.senhaApp,
      this.telefone,
      this.endereco,
      this.dataNascimento,
      this.idCidade,
      this.permissao,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.firebasekey,
      this.cidade,
      this.secretariaId,
      this.foto);
  User(
      this.id,
      this.nome,
      this.email,
      this.senhaSite,
      this.senhaApp,
      this.telefone,
      this.endereco,
      this.dataNascimento,
      this.idCidade,
      this.permissao,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.firebasekey,
      this.cidade,
      this.secretariaId);

  @override
  String toString() {
    return 'User{id: $id, nome: $nome, email: $email, senhaSite: $senhaSite, senhaApp: $senhaApp, telefone: $telefone, endereco: $endereco, dataNascimento: $dataNascimento, idCidade: $idCidade, permissao: $permissao, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, firebasekey: $firebasekey, cidade: $cidade, SecretariaId: $secretariaId}';
  }
}
