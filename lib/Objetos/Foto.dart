import 'package:json_annotation/json_annotation.dart';

part 'Foto.g.dart';

@JsonSerializable()
class Foto {
  int id_foto;
  String link;
  int id_user;
  int id_protocolo;
  String texto;
  DateTime hora_publicacao;
  bool isSelected;

  factory Foto.fromJson(Map<String, dynamic> json) => _$FotoFromJson(json);

  Foto(this.id_foto, this.link, this.id_user, this.id_protocolo, this.texto,
      this.hora_publicacao);
}
