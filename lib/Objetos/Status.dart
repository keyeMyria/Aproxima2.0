import 'package:json_annotation/json_annotation.dart';

part 'Status.g.dart';

@JsonSerializable()
class Status {
  int idStatus;
  String descricao;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Status(this.idStatus, this.descricao);
}
