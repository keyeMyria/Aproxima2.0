import 'package:aproxima/Objetos/Estado.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Cidade.g.dart';

@JsonSerializable()
class Cidade {
  String cidade;
  int id_cidade;
  int fk_estado;
  double lat;
  double lng;
  Estado estado;

  toJson() {
    return _$CidadeToJson(this);
  }

  factory Cidade.fromJson(Map<String, dynamic> json) => _$CidadeFromJson(json);

  Cidade(this.cidade, this.id_cidade, this.fk_estado, this.lat, this.lng,
      this.estado);

  factory Cidade.fromServer(json) => _$CidadeFromServer(json);
}
