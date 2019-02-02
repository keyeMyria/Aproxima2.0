import 'package:aproxima/Objetos/User.dart';

class News {
  String id_user;
  String noticia;
  DateTime data;
  int tipo;
  User Responsavel;
  String sujeito;

  News(this.id_user, this.noticia, this.data, this.tipo, this.Responsavel,
      this.sujeito);

  Map<String, dynamic> toMap() {
    return {
      'id_user': id_user,
      'noticia': noticia,
      'data': data.millisecondsSinceEpoch,
      'tipo': tipo,
      'responsavel': Responsavel.toJson(),
      'sujeito': sujeito
    };
  }

  News.toJson(v) {
    id_user = v['id_user'];
    noticia = v['noticia'];
    data = DateTime.fromMillisecondsSinceEpoch(v['data']);
    tipo = v['tipo'];
    Responsavel = User.fromServer(v['responsavel']);
    sujeito = v['sujeito'];
  }
}
