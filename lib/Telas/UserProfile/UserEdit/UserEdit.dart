import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/UserProfile/UserEdit/UserEditController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class UserEdit extends StatefulWidget {
  User u;

  UserEdit(this.u);

  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserEditController uec = UserEditController(Helpers.user);
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 10.0, 15.0, 10.0);
  final TextEditingController nameController =
      new TextEditingController(text: '');
  final TextEditingController birthdayController =
      new MaskedTextController(text: '', mask: '00/00/0000');
  final TextEditingController telefoneController =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');

  @override
  changeProfilePhoto(BuildContext Context) {
    return showDialog(
      context: Context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Trocar Foto'),
          content: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Text('Galeria'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: uec.outUser,
        builder: (context, AsyncSnapshot<User> snap) {
          if (!snap.hasData) {
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());
          } else {
            if (nameController.text == '' || nameController.text == null) {
              nameController.text = snap.data.nome;
            }

            if (birthdayController.text == '' ||
                birthdayController.text == null) {
              if (snap.data.dataNascimento == null) {
                birthdayController.text = '';
              } else {
                String data = (snap.data.dataNascimento.day >= 10
                        ? snap.data.dataNascimento.day.toString()
                        : '0' + snap.data.dataNascimento.day.toString()) +
                    '/' +
                    (snap.data.dataNascimento.month >= 10
                        ? snap.data.dataNascimento.month.toString()
                        : '0' + snap.data.dataNascimento.month.toString()) +
                    '/' +
                    snap.data.dataNascimento.year.toString();
                birthdayController.text = data;
              }
            }

            if (telefoneController.text == '' ||
                telefoneController.text == null) {
              telefoneController.text = snap.data.telefone;
            }
            return Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  title: Text('Editar Perfil'),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          snap.data.nome = nameController.text;
                          snap.data.telefone = telefoneController.text;
                          var data =
                              birthdayController.text.toString().split('/');

                          print('DATA fDP ${data.toString()}');
                          snap.data.dataNascimento = new DateTime(
                              int.parse(data[2]),
                              int.parse(data[1]),
                              int.parse(data[0]));
                          uec.AtualizarPerfil(snap.data).then((b) {
                            if (b) {
                              _scaffoldKey.currentState
                                  .showSnackBar(new SnackBar(
                                content: Text('Atualizado com sucesso'),
                                duration:
                                    Duration(seconds: 1, milliseconds: 500),
                              ));
                              Future.delayed(Duration(seconds: 2)).then((d) {
                                Navigator.of(context).pop();
                              });
                            }
                          }).catchError((err) {
                            print('Error:${err.toString()}');
                          });
                        }),
                  ],
                ),
                body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                            'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'),
                      ),
                    ),
                    new FlatButton(
                        onPressed: () {
                          changeProfilePhoto(context);
                        },
                        padding: EdgeInsets.only(
                            top: 5, bottom: 30, left: 15, right: 15),
                        child: new Text(
                          "Trocar Foto",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )),
                    new Padding(
                      padding: ei,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.green,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
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
                        controller: birthdayController,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.green,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                            hintText: '01/01/0000',
                            labelText: 'Data de Nascimento',
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                    new Padding(
                      padding: ei,
                      child: TextFormField(
                        controller: telefoneController,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.phone_iphone,
                              color: Colors.green,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                            hintText: '(00) 0 0000-0000',
                            labelText: 'Celular',
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ],
                ));
          }
        });
  }
}
