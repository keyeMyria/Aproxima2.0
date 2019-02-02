import 'package:aproxima/Objetos/Tag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Tagss.g.dart';

@JsonSerializable()
class Tagss {
  int idtag;
  int idprotocolo;
  Tag tag;
  int inserted;

  factory Tagss.fromJson(Map<String, dynamic> json) => _$TagssFromJson(json);
  Tagss(this.idtag, this.idprotocolo, this.tag, this.inserted);
}
