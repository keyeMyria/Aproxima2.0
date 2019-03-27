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

  @override
  String toString() {
    return 'Foto{id_foto: $id_foto, link: $link, id_user: $id_user, id_protocolo: $id_protocolo, texto: $texto, hora_publicacao: $hora_publicacao, isSelected: $isSelected}';
  }

  factory Foto.fromJson(Map<String, dynamic> json) => _$FotoFromJson(json);

  Foto(this.id_foto, this.link, this.id_user, this.id_protocolo, this.texto,
      this.hora_publicacao);
}
