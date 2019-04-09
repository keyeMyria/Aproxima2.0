import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class CadastrarUsuarioController implements BlocBase {
  User _user;
  BehaviorSubject<User> _controllerUser = new BehaviorSubject<User>();

  Stream<User> get outUser => _controllerUser.stream;

  Sink<User> get inUser => _controllerUser.sink;

  BehaviorSubject<Cidade> _controllerCidade = new BehaviorSubject<Cidade>();

  Stream<Cidade> get outCidade => _controllerCidade.stream;

  Sink<Cidade> get inCidade => _controllerCidade.sink;

  Fetch() {
    if (_user == null) {
      _controllerUser.add(new User.Empty());
    }
  }

  @override
  void dispose() {
    _controllerUser.close();
    _controllerCidade.close;
  }

  void Filter(String text) {}

  Future registerUser(User usuario) {
    var url =
        "http://www.aproximamais.net/webservice/json.php?cadastraruser=true&t=${DateTime.now().millisecondsSinceEpoch}";

    print('url ${url}');
    print('User: ${usuario.toString()}');
    return _controllerCidade.first.then((cidade) {
      print('CHEGOU AQUI');
      return http.post(url, body: {
        "Cadastrar": "true",
        "telefone": usuario.telefone,
        "nome": usuario.nome,
        "data_nascimento":
            '${usuario.dataNascimento.year}-${usuario.dataNascimento.month}-${usuario.dataNascimento.day}',
        "email": usuario.email,
        "strike": 0.toString(),
        "senha_app": usuario.senhaApp,
        "senha_site": '',
        "permissao": '0',
        "secretaria_id": 'null',
        "idCidade": cidade.id_cidade.toString(),
        'firebasekey': '',
        'endereco': '', //usuario.endereco,
      }).then((response) {
        print('AQUI DEMO');
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
      }).catchError((err) {
        print('ERRO POST: ${err.toString()}');
      });
    }).catchError((err) {
      print('ERRO: ${err.toString()}');
    });
    ;

    //http.read("http://example.com/foobar.txt").then(print);
  }
}
