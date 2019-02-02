import 'package:json_annotation/json_annotation.dart';

part 'Notificacao.g.dart';

@JsonSerializable()
class Notificacao {
  String image;
  String id_protocolo;
  String title;
  String message;
  int behaivior;
  List<String> firebasekeys;
  String topic;

  factory Notificacao.fromJson(Map<String, dynamic> json) =>
      _$NotificacaoFromJson(json);

  Notificacao(this.image, this.id_protocolo, this.title, this.message,
      this.behaivior, this.firebasekeys, this.topic);
}
