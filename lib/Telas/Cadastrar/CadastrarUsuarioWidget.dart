import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Estado.dart';
import 'package:aproxima/Objetos/Pais.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/Cadastrar/CadastrarUsuarioController.dart';
import 'package:aproxima/Telas/Login/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CadastrarUsuarioWidget extends StatefulWidget {
  LoginController lc;

  CadastrarUsuarioWidget(this.lc);

  @override
  _CadastrarUsuarioWidgetState createState() => _CadastrarUsuarioWidgetState();
}

class _CadastrarUsuarioWidgetState extends State<CadastrarUsuarioWidget> {
  final _formKey = GlobalKey<FormState>();

  CadastrarUsuarioController cuc;
  var controllerTelefone =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');
  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerSenha = new TextEditingController(text: '');
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerCep = new MaskedTextController(text: '', mask: '000000-000');
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    cuc = new CadastrarUsuarioController();

    // TODO: implement build
    return StreamBuilder(
        stream: cuc.outUser,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          //print('CHEGOU AQUI LOLOLO' + snapshot.data.toString());
          if (snapshot.data != null) {
            return StreamBuilder(
                stream: cuc.outUser,
                builder: (BuildContext context, AsyncSnapshot<User> ue) {
                  if (!ue.hasData) {
                    cuc.Fetch();
                    return new Center(
                      child: new Text(''),
                    );
                  } else {
                    return new Scaffold(
                        key: scaffoldKey,
                        appBar: new AppBar(
                          title: new Text("Registro"),
                          backgroundColor: Helpers.blue_default,
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        floatingActionButton: FloatingActionButton(
                          backgroundColor: Helpers.blue_default,
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, we want to show a Snackbar
                              scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text('Registrando')));
                              cuc.registerUser(snapshot.data).then((value) {
                                if (value == 0) {
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Registrado Com Sucesso')));

                                  widget.lc.inEmail.add(snapshot.data.email);

                                  Future.delayed(Duration(seconds: 2))
                                      .then((v) {
                                    Navigator.of(context).pop();
                                  });
                                } else if (value == 1) {
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          'Erro ao efetuar Cadastro: Email já cadastrado')));
                                } else {
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          'Erro ao efetuar Cadastro: Tente novamente mais tarde')));
                                }
                              });
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        bottomNavigationBar: BottomAppBar(
                          shape: CircularNotchedRectangle(),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.search),
                                color: Helpers.green_default,
                                disabledColor: Helpers.green_default,
                                onPressed: null,
                              ),
                            ],
                          ),
                          color: Helpers.green_default,
                        ),
                        body: new SingleChildScrollView(
                            child: new Padding(
                                padding: EdgeInsets.all(5.0),
                                child: new Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        buildUser(snapshot.data, cuc),
                                        buildEnderecoForm(snapshot.data, cuc)
                                      ],
                                    )))));
                  }
                });
          } else {
            cuc.Fetch();
          }
        });
  }

  buildEnderecoForm(User u, CadastrarUsuarioController cuc) {
    final Pais p = Pais(0, 'Brasil', 'BR');
    final Estado e = Estado('Parana', 0, 'PR', 0, p);
    final Cidade c = Cidade('Tibagi', 1, 0, 0.0, 0.0, e);
    final Cidade c1 = Cidade('Ponta Grossa', 2, 0, 0.0, 0.0, e);
    return new Column(children: <Widget>[
      Padding(
          padding: ei,
          child: PopupMenuButton<Pais>(
            onSelected: (Pais result) {},
            initialValue: p,
            child: Container(
              width: MediaQuery.of(context).size.width * 03,
              height: MediaQuery.of(context).size.height * .07,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 11, left: 3),
                      child: Icon(
                        Icons.place,
                        color: Helpers.green_default,
                      )),
                  Expanded(
                    child: Container(
                      height: 60,
                      width: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Text(
                            'Brasil',
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Helpers.green_default,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Helpers.green_default,
                              style: BorderStyle.solid,
                              width: 1)),
                    ),
                  ),
                ],
              ),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Pais>>[
                  PopupMenuItem<Pais>(
                    value: p,
                    child: Container(
                      child: Text(
                        'Brasil',
                      ),
                    ),
                  )
                ],
          )),
      Padding(
          padding: ei,
          child: PopupMenuButton<Estado>(
            onSelected: (Estado result) {},
            initialValue: e,
            child: Container(
              width: MediaQuery.of(context).size.width * 03,
              height: MediaQuery.of(context).size.height * .07,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 11, left: 3),
                      child: Icon(
                        Icons.place,
                        color: Helpers.green_default,
                      )),
                  Expanded(
                    child: Container(
                      height: 60,
                      width: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Text(
                            'Paraná',
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Helpers.green_default,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Helpers.green_default,
                              style: BorderStyle.solid,
                              width: 1)),
                    ),
                  ),
                ],
              ),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Estado>>[
                  PopupMenuItem<Estado>(
                    value: e,
                    child: Container(
                      child: Text(
                        'Paraná',
                      ),
                    ),
                  )
                ],
          )),
      StreamBuilder(
        stream: cuc.outCidade,
        builder: (context, AsyncSnapshot<Cidade> snap) {
          return Padding(
              padding: ei,
              child: PopupMenuButton<Cidade>(
                onSelected: (Cidade result) {
                  cuc.inCidade.add(result);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 03,
                  height: MediaQuery.of(context).size.height * .07,
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 11, left: 3),
                          child: Icon(
                            Icons.place,
                            color: Helpers.green_default,
                          )),
                      Expanded(
                        child: Container(
                          height: 60,
                          width: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 4)),
                              Text(
                                snap.hasData
                                    ? snap.data.cidade
                                    : 'SELECIONE A CIDADE',
                                style: TextStyle(fontSize: 14),
                              ),
                              Icon(
                                Icons.arrow_downward,
                                color: Helpers.green_default,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Helpers.green_default,
                                  style: BorderStyle.solid,
                                  width: 1)),
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Cidade>>[
                      PopupMenuItem<Cidade>(
                        value: c,
                        child: Container(
                          child: Text(
                            'Tibagi',
                          ),
                        ),
                      ),
                      PopupMenuItem<Cidade>(
                        value: c1,
                        child: Container(
                          child: Text(
                            'Ponta Grossa',
                          ),
                        ),
                      ),
                    ],
              ));
        },
      )
    ]);
  }

  buildUser(User data, CadastrarUsuarioController cuc) {
    return Column(children: <Widget>[
      Padding(padding: ei),
      new Padding(
        padding: ei,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Nome';
            } else {
              data.nome = value;
              cuc.inUser.add(data);
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.account_circle,
                color: Helpers.green_default,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              hintText: 'João da Silva',
              labelText: 'Nome Completo',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Email';
            } else {
              if (value.contains('@')) {
                data.email = value;
                cuc.inUser.add(data);
              } else {
                return 'Email Invalido';
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.email,
                color: Helpers.green_default,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              hintText: 'contatorbsoftware@gmail.com',
              labelText: 'Email',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          controller: controllerTelefone,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Celular';
            } else {
              if ('(00) 0 0000-0000'.length != value.length) {
                return 'Celular Invalido';
              } else {
                data.telefone = value;
                cuc.inUser.add(data);
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.phone_android,
                color: Helpers.green_default,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              hintText: '(00)0 0000-0000',
              labelText: 'Celular',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          controller: controllerDataNascimento,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher a Data de Nascimento';
            } else {
              if (value.length != '00/00/0000'.length) {
                return 'Data de Nascimento Invalida!';
              } else {
                var s = value.split('/');
                data.dataNascimento = new DateTime(
                    int.parse(s[2]), int.parse(s[1]), int.parse(s[0]));
                print(
                    'Data Nascimento ' + data.dataNascimento.toIso8601String());
                cuc.inUser.add(data);
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.date_range,
                color: Helpers.green_default,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              labelText: 'Data de Nascimento',
              hintText: 'dd/mm/aaaa',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          controller: controllerSenha,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher a Senha';
            } else {
              if (value.length < 6) {
                return 'Senha é Muito Curta!';
              } else {
                var s = value.split('/');
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: Helpers.green_default,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              hintText: 'Maggie1723',
              labelText: 'Senha',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher a Senha';
            } else {
              if (value.length < 6) {
                return 'Senha é Muito Curta!';
              } else {
                if (value == controllerSenha.text) {
                  data.senhaApp = value;
                  cuc.inUser.add(data);
                } else {
                  return 'Senhas não conferem';
                }
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: Helpers.green_default,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              hintText: 'Maggie1723',
              labelText: 'Repita a Senha',
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic)),
        ),
      ),
    ]);
  }
}
