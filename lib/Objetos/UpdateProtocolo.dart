import 'package:aproxima/Objetos/Status.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UpdateProtocolo.g.dart';

@JsonSerializable()
class UpdateProtocolo {
  int id;
  int user_id;
  String descricao;
  String titulo;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String display_name;
  String anonimo;
  String id_protocolo;
  String id_status;
  Status status;
  User user;

  factory UpdateProtocolo.fromJson(Map<String, dynamic> json) =>
      _$UpdateProtocoloFromJson(json);
  UpdateProtocolo(
      this.id,
      this.user_id,
      this.descricao,
      this.titulo,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.display_name,
      this.anonimo,
      this.id_protocolo,
      this.id_status,
      this.status,
      this.user);
}
