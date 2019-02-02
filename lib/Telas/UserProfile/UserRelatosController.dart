import 'dart:convert';

import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Estado.dart';
import 'package:aproxima/Objetos/Pais.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class UserRelatosController implements BlocBase {
  List<Protocolo> Protocolos;
  BehaviorSubject<List<Protocolo>> _controllerUserRelatos =
      new BehaviorSubject<List<Protocolo>>();

  Stream<List<Protocolo>> get outUserRelatos => _controllerUserRelatos.stream;

  Sink<List<Protocolo>> get inUserRelatos => _controllerUserRelatos.sink;
  @override
  void dispose() {
    _controllerUserRelatos.close();
  }

  Cidade castro = new Cidade('Castro', 0, 0, 0.0, 0.0,
      new Estado('Paraná', 0, 'PR', 0, new Pais(0, 'Brasil', 'Br')));

  UserRelatosController(user) {
    Fetch(user);
  }

  Fetch(user) {
    Protocolos = new List();
    //TODO alterar id da cidade de acordo com a cidade do usuario
    http
        .get(
            'http://www.aproximamais.net/webservice/json.php?buscaprotocolouser=${user}')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
        print(v.toString());
        Protocolos.add(new Protocolo.fromJson(v));
      }

      inUserRelatos.add(Protocolos);
    });
  }
}
