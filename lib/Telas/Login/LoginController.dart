import 'dart:convert';
import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  LoginController() {
    SharedPreferences.getInstance().then((sp) {
      inEmail.add(sp.getString('Login'));
      inSenha.add(sp.getString('Senha'));
    }).catchError((err) {
      print('Error SP: ${err.toString()}');
    });
  }

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
          sp.setString('Login', email);
          sp.setString('Senha', senha);
          print('AQUI PAIS ${Helpers.user.cidade.estado.toString()}');
          Helpers.fbmsg.subscribeToTopic('${Helpers.user.cidade.cidade}');
          _SignInAnonymously();
          return Helpers.user != null;
        }).catchError((err) {
          print('Error: ${err.toString()}');
          return false;
        });
      });
    });
  }

  Future<String> _SignInAnonymously() async {
    final FirebaseUser user = await auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInAnonymously succeeded: $user';
  }

  Future<bool> doAutoLogin() {
    return SharedPreferences.getInstance().then((sp) {
      return sp.getBool('logout') == null ? false : sp.getBool('logout');
    }).catchError((err) {
      print('Error SP: ${err.toString()}');
      return true;
    });
  }
}
