import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Helpers/NotificacoesHelper.dart';
import 'package:aproxima/ListModel.dart';
import 'package:aproxima/Objetos/News.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Telas/Cadastrar/CadastrarUsuarioWidget.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:aproxima/Telas/Login/LoginController.dart';
import 'package:aproxima/Widgets/PaginaPrincipal/PaginaPrincipalPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter;
  DatabaseReference _counterRef;
  DatabaseReference _messagesRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  bool _anchorToBottom = false;

  String _kTestKey = 'Hello';
  String _kTestValue = 'world!';
  DatabaseError _error;

  FirebaseMessaging fbmsg = new FirebaseMessaging();
  bool hasDesejo = false;
  bool hasPush = false;
  Map<String, dynamic> pushData;

  bool logout;

  BuildContext c;
  static const d = const Duration(seconds: 2);
  Future<FirebaseApp> getConfig() {
    return FirebaseApp.configure(
      name: 'database',
      options: Platform.isIOS
          ? const FirebaseOptions(
              apiKey: 'AIzaSyCbXnPT3n-bTsDmTYPfNAk4zWCn88SlnF4',
              googleAppID: '1:29966875189:android:48a756ff5384df0d',
              gcmSenderID: '29966875189',
              databaseURL: 'https://aproximamais-b84ee.firebaseio.com',
            )
          : const FirebaseOptions(
              apiKey: 'AIzaSyCbXnPT3n-bTsDmTYPfNAk4zWCn88SlnF4',
              googleAppID: '1:29966875189:android:48a756ff5384df0d',
              gcmSenderID: '29966875189',
              databaseURL: 'https://aproximamais-b84ee.firebaseio.com',
            ),
    ).then((app) {
      return app;
    });
  }

  var flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS =
        new IOSInitializationSettings(requestAlertPermission: true);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: NotificacoesHelper().onSelectNotification);
    NotificacoesHelper.flutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin;

    //TODO DEFINIR BEHAIVIOURS DAS PUSHS
    fbmsg.configure(
      onLaunch: (Map<String, dynamic> msg) {
        NotificacoesHelper().showNotification(msg, context);
      },
      onResume: (Map<String, dynamic> msg) {
        NotificacoesHelper().showNotification(msg, context);
      },
      onMessage: (Map<String, dynamic> msg) {
        NotificacoesHelper().showNotification(msg, context);

        /*pushData = msg;
        hasPush = true;*/
      },
    );
    NotificacoesHelper().showDailyAtTime();

    fbmsg.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, badge: true, sound: true));
    fbmsg.onIosSettingsRegistered.listen((IosNotificationSettings) {
      print("dispositivo registrado");
    });
    fbmsg.getToken().then((token) {
      print("TOKEN REGISTRADO" + token);
      Helpers.token = token;
    });

    fbmsg.subscribeToTopic('global');
    fbmsg.subscribeToTopic('teste');
    Helpers.fbmsg = fbmsg;
    print('Buscando user');
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly
    getConfig().then((value) {
      final FirebaseDatabase database = FirebaseDatabase(app: value);
    });

    _list = ListModel<String>(
      listKey: _listKey,
      initialItems: <String>['Bem Vindo ao AproximA+'],
      removedItemBuilder: _buildRemovedItem,
    );
    Future.delayed(Duration(seconds: 4)).then((d) {
      insert();
      Future.delayed(Duration(seconds: 4)).then((d) {
        insert();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final LoginController lc = LoginController();

  ListModel<String> _list;
  TextStyle txs = TextStyle(color: Colors.white);
  OutlineInputBorder oib = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.00),
      gapPadding: 4.00,
      borderSide: BorderSide(
          width: 2.00, style: BorderStyle.solid, color: Colors.white));
  final _formKey = GlobalKey<FormState>();
  String _selectedItem;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildRemovedItem(
      String item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  void insert() {
    final int index =
        _selectedItem == null ? _list.length : _list.indexOf(_selectedItem);
    if (index == 2) {
      try {
        _list.insert(index,
            'Melhor... Poderá informar a prefeitura sobre problemas que afetam o cotidiano da sua cidade!!');
      } catch (err) {
        print(err);
      }
    }
    if (index == 1) {
      try {
        _list.insert(
            index, 'Aqui você fica por dentro das novidades do seu municipio!');
      } catch (err) {
        print(err);
      }
    }
  }

  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
      print(response);
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("${appName} isn't installed."),
          duration: new Duration(seconds: 4),
        ));
      }
    }
  }

  void whatsAppOpen() async {
    //print('ENTROU AQUI');
    var whatsappUrl =
        "whatsapp://send?phone=5542999319375&text=Ola, Gostaria de Conversar sobre o Aplicativo AproximaMais,";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  var emailController = TextEditingController(text: '');
  var senhaController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.transparent,
          tooltip: 'Powered By',
          onPressed: () {
            whatsAppOpen();
          },
          child: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: AssetImage('assets/logorb.png'),
          ),
        ),
        body: new Container(
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's
                  // Colors class.
                  Colors.blue[800],
                  Colors.blue[700],
                  Colors.blue[600],
                  Colors.blue[400],
                ],
              ),
            ),
            child: new SingleChildScrollView(
              child: new Container(
                  child: new Form(
                key: _formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedList(
                      shrinkWrap: true,
                      key: _listKey,
                      initialItemCount: _list.length,
                      itemBuilder: _buildItem,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    ),
                    /*Image.asset('assets/logo_sem_texto_teste.png',
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.15),*/
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: StreamBuilder(
                            stream: lc.outEmail,
                            builder: (context, snap) {
                              if (emailController.text == '' ||
                                  emailController.text == null) {
                                if (snap.hasData) {
                                  emailController.text = snap.data;
                                }
                              }
                              return TextField(
                                key: new Key('Email'),
                                controller: emailController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
//                        controller:
                                //                          new TextEditingController(text: desejo.Titulo),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                    helperStyle: txs,
                                    border: oib,
                                    hintText: 'Email',
                                    hintStyle:
                                        TextStyle(color: Colors.black54)),
                                autocorrect: false,
                                onChanged: (email) {
                                  lc.inEmail.add(email);
                                },
                              );
                            })),
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: StreamBuilder(
                            stream: lc.outSenha,
                            builder: (context, snap) {
                              if (senhaController.text == '' ||
                                  senhaController.text == null) {
                                if (snap.hasData) {
                                  senhaController.text = snap.data;
                                  lc.doAutoLogin().then((isLoginOut) {
                                    if (!isLoginOut) {
                                      doLogin();
                                    }
                                  });
                                }
                              }
                              return TextField(
                                obscureText: true,
                                controller: senhaController,
                                key: new Key('Senha'),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
//                        controller:
                                //                          new TextEditingController(text: desejo.Titulo),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    helperStyle: txs,
                                    border: oib,
                                    hintText: 'Senha',
                                    hintStyle:
                                        TextStyle(color: Colors.black54)),
                                autocorrect: false,
                                onChanged: (senha) {
                                  lc.inSenha.add(senha);
                                },
                              );
                            })),
                    new Row(
                      children: <Widget>[
                        new RaisedButton(
                          onPressed: () => doLogin(),
                          child: new Text(
                            'Entrar',
                            style: txs,
                            textAlign: TextAlign.center,
                          ),
                          color: Colors.black,
                          shape: oib,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    new Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    new Row(
                      children: <Widget>[
                        new RaisedButton(
                          onPressed: () {},
                          child: new Text(
                            'Esqueci Minha Senha',
                            style: txs,
                            textAlign: TextAlign.center,
                          ),
                          color: Colors.transparent,
                          shape: oib,
                        ),
                        new Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0)),
                        new RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CadastrarUsuarioWidget(lc),
                                ));
                          },
                          child: new Text(
                            'Registrar',
                            style: txs,
                            textAlign: TextAlign.center,
                          ),
                          color: Colors.transparent,
                          shape: oib,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              )), // This trailing comma makes auto-formatting nicer for build methods.
            )));
  }

  Future<void> openNews(News n, context) {
    print(n.toString());
    switch (n.tipo) {
      case 0:
        //print('Entrou aqui case 0');
        print(
            ' http://www.aproximamais.net/webservice/json.php?buscaprotocoloid=' +
                n.sujeito);
        // BEHAIVIOUR PRA ABRIR PROTOCOLO
        http
            .get(
                'http://www.aproximamais.net/webservice/json.php?buscaprotocoloid=' +
                    n.sujeito)
            .then((response) {
          print('RESPONSE AQUI: ${json.decode(response.body)}');
          var j = json.decode(response.body);
          Protocolo p;
          for (var v in j) {
            print(v.toString());
            p = new Protocolo.fromJson(v);
          }
          print(p.toString());
          if (p != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComentarioPage(p),
                ));
          }
        }).catchError((err) {
          print('error: ${err.toString()}');
        });
    }
  }

  CheckNewUser() {}

  Widget buildFakeChat() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _list.length,
          itemBuilder: _buildItem,
        ));
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  doLogin() {
    if (emailController.text != '') {
      if (senhaController.text != '') {
        lc.inEmail.add(emailController.text);
        lc.inSenha.add(senhaController.text);
        lc.EfetuarLogin().then((b) {
          if (b) {
            SharedPreferences.getInstance().then((sp) {
              sp.getBool('FirstLogin') == null
                  ? sp.setBool('FirstLogin', true)
                  : null;
              if (!sp.getBool('FirstLogin')) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModoListaPage(),
                    ));
              } else {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModoListaPage(),
                    ));
              }
            });
          }
        });
      }
    }
  }
}
