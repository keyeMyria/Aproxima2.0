import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Foto.dart';
import 'package:aproxima/Objetos/Secretaria.dart';
import 'package:aproxima/Objetos/Status.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Protocolo.g.dart';

@JsonSerializable()
class Protocolo {
  int id;
  double lat;
  double lng;
  String titulo;
  String descricao;
  int id_status;
  int user_id;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  int cidade_id;
  int secretaria_id;
  String endereco;
  String bairro;
  int permissao;
  int prioridade;
  String anonimo;
  Cidade cidade;
  User usuario;
  Status status;
  Secretaria secretaria;
  List<Tagss> tags;
  List<Foto> fotos;
  List<UpdateProtocolo> updates_protocolos;
  bool inserted;
  Marker m;
  String dlink;

  factory Protocolo.fromJson(Map<String, dynamic> json) =>
      _$ProtocoloFromJson(json);

  Protocolo(
      this.id,
      this.lat,
      this.lng,
      this.titulo,
      this.descricao,
      this.id_status,
      this.user_id,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.cidade_id,
      this.secretaria_id,
      this.endereco,
      this.bairro,
      this.permissao,
      this.prioridade,
      this.anonimo,
      this.cidade,
      this.usuario,
      this.status,
      this.secretaria,
      this.tags,
      this.fotos,
      this.updates_protocolos,
      this.inserted);

  toJson() {
    return _$ProtocoloToJson(this);
  }

  @override
  String toString() {
    return 'Protocolo{id: $id, lat: $lat, lng: $lng, titulo: $titulo, descricao: $descricao, id_status: $id_status, user_id: $user_id, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, cidade_id: $cidade_id, secretaria_id: $secretaria_id, endereco: $endereco, bairro: $bairro, permissao: $permissao, prioridade: $prioridade, anonimo: $anonimo, cidade: $cidade, usuario: $usuario, status: $status, secretaria: $secretaria, tags: $tags, fotos: $fotos, updates_protocolos: $updates_protocolos, inserted: $inserted}';
  }

  Protocolo.Empty();
}
