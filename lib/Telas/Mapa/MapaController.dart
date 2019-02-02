import 'dart:convert';

import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class MapaController implements BlocBase {
  List<Protocolo> Protocolos;
  BehaviorSubject<List<Protocolo>> _controllerMapa =
      new BehaviorSubject<List<Protocolo>>();

  Stream<List<Protocolo>> get outMapa => _controllerMapa.stream;

  Sink<List<Protocolo>> get inMapa => _controllerMapa.sink;
  @override
  void dispose() {
    _controllerMapa.close();
  }

  MapaController() {
    Fetch();
  }
  Fetch() {
    Protocolos = new List();
    //TODO alterar id da cidade de acordo com a cidade do usuario
    http
        .get(
            'http://www.aproximamais.net/webservice/json.php?buscaprotocolocidade=1')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
        Protocolos.add(new Protocolo.fromJson(v));
      }
      inMapa.add(Protocolos);
    });
  }
}
