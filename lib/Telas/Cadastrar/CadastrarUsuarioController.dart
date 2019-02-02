import 'package:aproxima/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class CadastrarUsuarioController implements BlocBase {
  User _user;
  BehaviorSubject<User> _controllerUser = new BehaviorSubject<User>();

  Stream<User> get outUser => _controllerUser.stream;

  Sink<User> get inUser => _controllerUser.sink;

  Fetch() {
    if (_user == null) {
      _controllerUser.add(new User.Empty());
    }
  }

  @override
  void dispose() {
    _controllerUser.close();
  }

  void Filter(String text) {}

  Future registerUser(User usuario) {
    var url =
        "http://www.aproximamais.net/webservice/json.php?cadastraruser=true";

    return http.post(url, body: {
      "Cadastrar": "true",
      "celular": usuario.telefone,
      "nome": usuario.nome,
      "data_nascimento": usuario.dataNascimento.toIso8601String(),
      "email": usuario.email,
      "strike": 0.toString(),
      "senha": usuario.senhaApp,
      'endereco': usuario.endereco,
    }).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.body.contains('Cadastrado com sucesso!')) {
        return 0;
      } else if (response.body.contains('Duplicate entry') &&
          response.body.contains('email')) {
        return 1;
      } else {
        return 2;
      }
    });

    //http.read("http://example.com/foobar.txt").then(print);
  }
}
