import 'dart:convert';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController implements BlocBase {
  BehaviorSubject<String> _controllerEmail = new BehaviorSubject<String>();
  BehaviorSubject<String> _controllerSenha = new BehaviorSubject<String>();

  Stream<String> get outEmail => _controllerEmail.stream;

  Sink<String> get inEmail => _controllerEmail.sink;

  Stream<String> get outSenha => _controllerSenha.stream;

  Sink<String> get inSenha => _controllerSenha.sink;

  @override
  void dispose() {
    _controllerEmail.close();
    _controllerSenha.close();
  }

  Future<bool> EfetuarLogin() {
    print('Iniciando Login LOLOLOLOLOLololo');
    return outEmail.first.then((email) {
      print('Dados: ${email}');
      return outSenha.first.then((senha) {
        print('Dados: ${email} ${senha}');
        return http.post(
            'http://www.aproximamais.net/webservice/json.php?login=true',
            body: {
              "user": email,
              "senha": senha,
              "email": email
            }).then((response) async {
          print(response.body);
          print('AQUI DEMONIO');
          print('RESPONSE AQUI: ${json.decode(response.body)}');
          Helpers.user = User.fromJson(json.decode(response.body)[0]);
          print('AQUI USUARIO FDP ${Helpers.user.toString()}');
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString('User', json.encode(Helpers.user));
          print('AQUI PAIS ${Helpers.user.cidade.estado.toString()}');
          return Helpers.user != null;
        }).catchError((err) {
          print('Error: ${err.toString()}');
          return false;
        });
      });
    });
  }
}
