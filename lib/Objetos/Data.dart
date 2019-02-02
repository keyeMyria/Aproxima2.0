import 'package:aproxima/Objetos/Payload.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Data.g.dart';

@JsonSerializable()
class Data {
  String protocolo;
  String image;
  bool is_backgroud;
  Payload payload;
  String title;
  String message;
  String timestamp;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Data(this.protocolo, this.image, this.is_backgroud, this.payload, this.title,
      this.message, this.timestamp);
}
