import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Tag.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

class EditarProtocoloController implements BlocBase {
  BehaviorSubject<Protocolo> _controllerEditarProtocolo =
      new BehaviorSubject<Protocolo>();
  Stream<Protocolo> get outEditProtocolo => _controllerEditarProtocolo.stream;

  Sink<Protocolo> get inEditProtocolo => _controllerEditarProtocolo.sink;

  EditarProtocoloController(Protocolo p) {
    inEditProtocolo.add(p);
  }

  Future<bool> AtualizarProtocolo(Protocolo p, Tag t) {
    var url =
        "http://www.aproximamais.net/webservice/json.php?atualizarpermissoesprotocolo=true";
    return http.post(url, body: {
      "lat": p.lat.toString(),
      "lng": p.lng.toString(),
      "endereco": p.endereco.toString(),
      'tag': t.id.toString(),
      'descricao': p.descricao.toString(),
      'titulo': p.titulo.toString(),
      'anonimo': p.anonimo.toString(),
      'id_protocolo': p.id.toString(),
      'permissao': p.permissao.toString(),
      'userup': 0.toString()
    }).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return true;
    }).catchError((err) {
      print('error:${err.toString()}');
      return false;
    });
  }

  @override
  void dispose() {
    _controllerEditarProtocolo.close();
  }
}
