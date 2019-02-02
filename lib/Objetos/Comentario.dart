import 'package:aproxima/Objetos/Apoio.dart';
import 'package:aproxima/Objetos/User.dart';

class Comentario {
  User criador;
  List<Apoio> apoios;
  DateTime created_at;
  String comentario;
  List<Comentario> comentarios;

  @override
  String toString() {
    return 'Comentario{criador: $criador, apoios: $apoios, created_at: $created_at, comentario: $comentario, comentarios: $comentarios}';
  }

  Comentario(this.criador, this.apoios, this.created_at, this.comentario,
      this.comentarios);

  Comentario.fromJson(j) {
    this.criador = j['usuario'];
    this.apoios = j['apoios'];
    this.created_at = j[''];
    this.comentario = j[''];
    this.comentarios = j[''];
  }

  getApoiosMap() {
    if (apoios != null) {
      List<Map<String, dynamic>> aa = new List();
      for (Apoio a in apoios) {
        aa.add(a.toJson());
      }
      return aa.toSet();
    } else {
      return null;
    }
  }

  getComentarioMap() {
    if (comentarios != null) {
      List<Map<String, dynamic>> aa = new List();
      for (Comentario a in comentarios) {
        aa.add(a.toMap());
      }
      return aa.toSet();
    } else {
      return null;
    }
  }

  toMap() {
    return {
      'usuario': criador.toJson(),
      'apoios': getApoiosMap(),
      'data': created_at.millisecondsSinceEpoch,
      'comentario': comentario,
      'comentarios': getComentarioMap(),
    };
  }

  Comentario.toJson(v) {
    criador = User.fromServer(v['usuario']);
    apoios = v['apoios'];
    created_at = DateTime.fromMillisecondsSinceEpoch(v['data']);
    comentario = v['comentario'];
    comentarios = v['comentarios'];
  }
}
