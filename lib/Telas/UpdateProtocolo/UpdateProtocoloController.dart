import 'dart:convert';

import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

class UpdateProtocoloController implements BlocBase {
  Protocolo p;

  UpdateProtocoloController(this.p);

  BehaviorSubject<UpdateProtocolo> _controllerUpdateProtocolo =
      new BehaviorSubject<UpdateProtocolo>();

  Stream<UpdateProtocolo> get outUpdateProtocolo =>
      _controllerUpdateProtocolo.stream;

  Sink<UpdateProtocolo> get inUpdateProtocolo =>
      _controllerUpdateProtocolo.sink;
  BehaviorSubject<int> _controllerSelectedStatus = new BehaviorSubject<int>();

  Stream<int> get outSelectedStatus => _controllerSelectedStatus.stream;

  Sink<int> get inSelectedStatus => _controllerSelectedStatus.sink;

  BehaviorSubject<String> _controllerThrowError = new BehaviorSubject<String>();

  Stream<String> get outThrowError => _controllerThrowError.stream;

  Sink<String> get inThrowError => _controllerThrowError.sink;

  @override
  void dispose() {
    _controllerUpdateProtocolo.close();
    _controllerThrowError.close();
    _controllerSelectedStatus.close();
  }

  Future<Protocolo> RegistrarUpdate(UpdateProtocolo up) {
    var url =
        'http://www.aproximamais.net/webservice/json.php?inserirupdateprotocolo=true';
    print('AQUI MERDA ${url}');
    return http.post(url, body: {
      'user_id': up.user.id.toString(),
      'descricao': up.descricao,
      'titulo': up.titulo,
      'id_status': up.status.idStatus.toString(),
      'display_name': up.user.nome,
      'anonimo': '0',
      'id_protocolo': up.id_protocolo.toString(),
      'secretariaid': '0'
    }).then((response) {
      print("Response status USER: ${response.statusCode}");
      print("Response body USER: ${response.body}");
      Protocolo p = Protocolo.fromJson(json.decode(response.body)[0]);
      print('PROTOCOLO : ${p.toString()}');
      return p;
    }).catchError((err) {
      print('Error:${err.toString()}');
      return null;
    });
  }
}
