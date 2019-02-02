import 'package:json_annotation/json_annotation.dart';

part 'Oficio.g.dart';

@JsonSerializable()
class Oficio {
  String Updated_at;
  String Created_at;
  String Link;
  String User_id;
  String Texto;
  String Secretaria_id;
  String Cidade_id;
  String Id;
  String Deleted_at;

  factory Oficio.fromJson(Map<String, dynamic> json) => _$OficioFromJson(json);

  Oficio(this.Updated_at, this.Created_at, this.Link, this.User_id, this.Texto,
      this.Secretaria_id, this.Cidade_id, this.Id, this.Deleted_at);
}
