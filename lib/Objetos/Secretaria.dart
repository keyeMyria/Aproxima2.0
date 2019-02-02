import 'package:aproxima/Objetos/Cidade.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Secretaria.g.dart';

@JsonSerializable()
class Secretaria {
  int id;
  String nome;
  int cidade_id;
  int permissao;
  Cidade cidade;

  factory Secretaria.fromJson(Map<String, dynamic> json) =>
      _$SecretariaFromJson(json);

  Secretaria(this.id, this.nome, this.cidade_id, this.permissao, this.cidade);
}
