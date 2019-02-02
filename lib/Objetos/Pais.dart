import 'package:json_annotation/json_annotation.dart';

part 'Pais.g.dart';

@JsonSerializable()
class Pais {
  int id_pais;
  String pais;
  String sigla;

  factory Pais.fromJson(Map<String, dynamic> json) => _$PaisFromJson(json);

  @override
  String toString() {
    return 'Pais{id_pais: $id_pais, pais: $pais, sigla: $sigla}';
  }

  Pais(this.id_pais, this.pais, this.sigla);

  toJson() {
    return _$PaisToJson(this);
  }
}
