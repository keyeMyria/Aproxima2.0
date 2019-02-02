import 'package:aproxima/Objetos/Pais.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Estado.g.dart';

@JsonSerializable()
class Estado {
  String estado;
  int id_estado;
  String sigla;
  int fk_pais;
  Pais pais;
  toJson() {
    return _$EstadoToJson(this);
  }

  @override
  String toString() {
    return 'Estado{estado: $estado, id_estado: $id_estado, sigla: $sigla, fk_pais: $fk_pais, pais: $pais}';
  }

  factory Estado.fromJson(Map<String, dynamic> json) => _$EstadoFromJson(json);
  Estado(this.estado, this.id_estado, this.sigla, this.fk_pais, this.pais);

  factory Estado.fromServer(json) => _$EstadoFromServer(json);
}
