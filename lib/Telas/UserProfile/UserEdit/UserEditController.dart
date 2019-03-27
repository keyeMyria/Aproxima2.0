import 'dart:convert';
import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

class UserEditController implements BlocBase {
  BehaviorSubject<User> _controllerUserEdit = new BehaviorSubject<User>();

  UserEditController(User user) {
    inUser.add(user);
  }

  BehaviorSubject<double> porcentagemVideo = new BehaviorSubject<double>();
  BehaviorSubject<double> porcentagemImagem = new BehaviorSubject<double>();
  Stream<User> get outUser => _controllerUserEdit.stream;

  Sink<User> get inUser => _controllerUserEdit.sink;

  BehaviorSubject<File> _controllerProfilePicture = new BehaviorSubject<File>();
  Stream<File> get outProfilePicture => _controllerProfilePicture.stream;

  Sink<File> get inProfilePicture => _controllerProfilePicture.sink;

  buscarProtocoloPorUsuario(String id) {}

  Future<bool> AtualizarPerfil(User u) {
    var url =
        'http://www.aproximamais.net/webservice/json.php?atualizaruser=true';
    return http.post(url, body: {
      'id': u.id.toString(),
      'nome': u.nome.toString(),
      'email': u.email.toString(),
      'senha_site': u.senhaSite.toString(),
      'senha_app': u.senhaApp.toString(),
      'telefone': u.telefone.toString(),
      'endereco': u.endereco.toString(),
      'data_nascimento': u.dataNascimento.toString(),
      "idCidade": u.idCidade.toString(),
      'permissao': u.permissao.toString(),
      'firebasekey': u.firebasekey.toString(),
      'secretaria_id': u.secretariaId.toString(),
      'created_at': u.createdAt.toString(),
    }).then((response) {
      print("Response status USER: ${response.statusCode}");
      print("Response body USER: ${response.body}");
      Helpers.user = User.fromJson(json.decode(response.body));
      print('USUARIO AQUI ${Helpers.user.toString()}');
      inUser.add(Helpers.user);
      return true;
    }).catchError((err) {
      print('Error:${err.toString()}');
      return false;
    });
  }

  @override
  void dispose() {
    _controllerUserEdit.close();
    _controllerProfilePicture.close();
  }
}
