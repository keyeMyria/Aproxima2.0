import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/UserProfile/UserEdit/UserEditController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';

class UserEditPage extends StatefulWidget {
  User u;

  UserEditPage(this.u);

  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEditPage> {
  UserEditController uec = UserEditController(Helpers.user);
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 10.0, 15.0, 10.0);
  final TextEditingController nameController =
      new TextEditingController(text: '');
  final TextEditingController birthdayController =
      new MaskedTextController(text: '', mask: '00/00/0000');
  final TextEditingController telefoneController =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');

  changeProfilePhoto(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              shape: Border.all(),
              title: new Text(
                'Trocar foto de Perfil?',
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Sair',
                    style: TextStyle(color: Helpers.green_default),
                  ),
                ),
                MaterialButton(
                  onPressed: () => updateProfilePicture(),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(color: Helpers.green_default),
                  ),
                )
              ],
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Icon(
                            Icons.photo,
                            color: Helpers.green_default,
                          )),
                      MaterialButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Icon(Icons.camera_alt,
                              color: Helpers.green_default))
                    ],
                  ),
                  StreamBuilder(
                      stream: uec.outProfilePicture,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return CircleAvatar(
                            backgroundImage: FileImage(snap.data),
                            radius: 75,
                          );
                        } else {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Helpers.green_default, width: 4)),
                            child: Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: Helpers.green_default,
                                size: 80,
                              ),
                            ),
                          );
                        }
                      })
                ],
              ));
        });
  }

  Future getImage(ImageSource imgsrc) async {
    ImagePicker.pickImage(source: imgsrc).then((f) {
      uec.inProfilePicture.add(f);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('AQUI INICIANDO');
    return StreamBuilder(
        stream: uec.outUser,
        builder: (context, AsyncSnapshot<User> snap) {
          if (!snap.hasData) {
            return Scaffold(
                body: new Container(
                    alignment: FractionalOffset.center,
                    child: new CircularProgressIndicator()));
          } else {
            print('USUARIO AQUI FILHO DA PUTA ${snap.data.toString()}');
            if (nameController.text == '' || nameController.text == null) {
              nameController.text = snap.data.nome;
            }
            if (birthdayController.text == '' ||
                birthdayController.text == null) {
              if (snap.data.dataNascimento == null) {
                print('AQUI CARALHO');
                birthdayController.text = '';
              } else {
                try {
                  print('AQUI CARALHO  2222');
                  print('AQUI DATA FILHO DA PUTA ${snap.data.dataNascimento}');
                  print(
                      ' DIA >${snap.data.dataNascimento.day} MES >${snap.data.dataNascimento.month}  ANO >${snap.data.dataNascimento.year}');
                  String data = (snap.data.dataNascimento.day >= 10
                          ? snap.data.dataNascimento.day.toString()
                          : '0' + snap.data.dataNascimento.day.toString()) +
                      '/' +
                      (snap.data.dataNascimento.month >= 10
                          ? snap.data.dataNascimento.month.toString()
                          : '0' + snap.data.dataNascimento.month.toString()) +
                      '/' +
                      snap.data.dataNascimento.year.toString();
                  print('DATA FDP ${data}');
                  birthdayController.text = data;
                } catch (err) {
                  print('Error: ${err.toString()}');
                  birthdayController.text = '';
                }
              }
            }

            if (telefoneController.text == '' ||
                telefoneController.text == null) {
              telefoneController.text = snap.data.telefone;
            }
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Helpers.green_default,
                  title: Text('Editar Perfil'),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          try {
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
                                Future.delayed(Duration(seconds: 2)).then((d) {
                                  Navigator.of(context).pop();
                                });
                              }
                            }).catchError((err) {
                              print('Error:${err.toString()}');
                            });
                          } catch (err) {
                            print('Error: ${err.toString()}');
                          }
                        }),
                  ],
                ),
                body: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                      child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          width: 150,
                          height: 150,
                          placeholder: Image.asset(
                            'assets/logo.png',
                            width: 150,
                            height: 150,
                          ),
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/aproximamais-b84ee.appspot.com/o/usuarios%2F${Helpers.user.id}.jpeg?alt=media&token=5cae4fd3-d3d4-44e4-893a-2349f6fda687'),
                    ),
                    new FlatButton(
                        onPressed: () {
                          changeProfilePhoto(context);
                        },
                        padding: EdgeInsets.only(
                            top: 5, bottom: 30, left: 15, right: 15),
                        child: new Text(
                          "Trocar Foto",
                          style: TextStyle(
                              color: Helpers.green_default,
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
                              color: Helpers.green_default,
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
                                color: Helpers.green_default,
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
                              color: Helpers.green_default,
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
                                color: Helpers.green_default,
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
                              color: Helpers.green_default,
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
                                color: Helpers.green_default,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ],
                )));
          }
        });
  }

  updateProfilePicture() {
    uec.porcentagemImagem.add(.0);
    FirebaseStorage storage = FirebaseStorage();
    var fileName = Helpers.user.id.toString() + ".jpeg";
    uec.outProfilePicture.first.then((f) {
      StorageUploadTask putFile =
          storage.ref().child("usuarios//$fileName").putFile(f);
      putFile.events.listen((event) {
        uec.porcentagemImagem.add((event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble()) *
            100);
        print('procentagem: ' + uec.porcentagemImagem.toString());
      }).onError((error) {});
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
                content: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  new CircularProgressIndicator(),
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new StreamBuilder(
                          stream: uec.porcentagemImagem.stream,
                          initialData: 0.0,
                          builder: (context, snapshot) {
                            if (snapshot.data.toStringAsFixed(2) == 100.00) {
                              Navigator.of(context).pop();
                            }
                            if (snapshot.data != null) {
                              return new Text(
                                  snapshot.data.toStringAsFixed(2) + '%');
                            } else {
                              return new Container();
                            }
                          }),
                      new Text("Carregando"),
                    ],
                  ),
                ]));
          });
    });
  }
}
