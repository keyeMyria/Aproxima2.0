import 'dart:convert';

import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Estado.dart';
import 'package:aproxima/Objetos/Pais.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class ModoListaController implements BlocBase {
  List<Protocolo> Protocolos;
  BehaviorSubject<List<Protocolo>> _controllerModoLista =
      new BehaviorSubject<List<Protocolo>>();

  Stream<List<Protocolo>> get outModoLista => _controllerModoLista.stream;

  Sink<List<Protocolo>> get inModoLista => _controllerModoLista.sink;
  @override
  void dispose() {
    _controllerModoLista.close();
  }

  Cidade castro = new Cidade('Castro', 0, 0, 0.0, 0.0,
      new Estado('Paraná', 0, 'PR', 0, new Pais(0, 'Brasil', 'Br')));

  ModoListaController() {
    Fetch();
  }
  Fetch() {
    Protocolos = new List();
    http
        .get(
            'http://www.aproximamais.net/webservice/json.php?buscaprotocolocidade=1')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
        print(v.toString());
        Protocolos.add(new Protocolo.fromJson(v));
      }
      //Protocolos = Protocolos.reversed.toList();
      inModoLista.add(Protocolos);
    });
  }
}
