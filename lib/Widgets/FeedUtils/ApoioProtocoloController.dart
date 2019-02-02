import 'dart:async';
import 'dart:convert';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Apoio.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class ApoioProtocoloController extends BlocBase {
  Protocolo p;
  DatabaseReference _protocoloRef;

  List<Apoio> Apoios;
  BehaviorSubject<List<Apoio>> _controllerApoioProtocolo =
      new BehaviorSubject<List<Apoio>>();

  Stream<List<Apoio>> get outApoio => _controllerApoioProtocolo.stream;

  Sink<List<Apoio>> get inApoio => _controllerApoioProtocolo.sink;
  StreamSubscription ss;

  @override
  void dispose() {
    _controllerApoioProtocolo.close();
  }

  DesapoiarProtocolo(Protocolo post, Apoio apoio) {
    Helpers.fbmsg.unsubscribeFromTopic('protocoloteste' + post.id.toString());
    _protocoloRef.child(apoio.chave).remove();
    for (int i = Apoios.length - 1; i >= 0; i--) {
      if (apoio.chave == Apoios[i].chave) {
        Apoios.removeAt(i);
        print(Apoios.toString());
      }
    }
    inApoio.add(Apoios);
  }

  bool ApoiarProtocolo(Protocolo post) {
    Helpers.fbmsg.subscribeToTopic('protocoloteste' + post.id.toString());
    _protocoloRef.push().set({
      'apoiador': Helpers.user.id,
      'data': DateTime.now().millisecondsSinceEpoch,
    }).then((v) {
      print('Inserido');
    });
    Helpers.nh.sendNotification({
      'title': '${Helpers.user.nome} Apoiou o protocolo ${post.titulo}',
      'responsavel': json.encode(Helpers.user),
      'tipo': 0.toString(),
      'sujeito': post.id.toString(),
      'topic': 'protocoloteste' + post.id.toString(),
      'foto': Helpers.user.foto == null
          ? 'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'
          : Helpers.user.foto,
      'data': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  ApoioProtocoloController(this.p) {
    _protocoloRef = FirebaseDatabase.instance
        .reference()
        .child('Protocolos')
        .child(p.id.toString())
        .child('Apoios')
        .reference();

    Apoios = new List();

    _protocoloRef.once().then((DataSnapshot dataSnapshot) {
      for (int i = 0; i < dataSnapshot.value.values.toList().length; i++) {
        Apoio a = new Apoio(
            dataSnapshot.value.values.toList()[i]['apoiador'],
            DateTime.fromMillisecondsSinceEpoch(
                dataSnapshot.value.values.toList()[i]['data']));
        a.chave = dataSnapshot.value.keys.toList()[i];
        Apoios.add(a);
      }
      inApoio.add(Apoios);
    }).catchError((err) {
      print('Error: ${err.toString()}');
    });
    _protocoloRef.onChildAdded.listen((event) {
      Apoio a = new Apoio(event.snapshot.value['apoiador'],
          DateTime.fromMillisecondsSinceEpoch(event.snapshot.value['data']));
      bool contains = false;
      for (Apoio ap in Apoios) {
        if (ap.chave == event.snapshot.key) {
          contains = true;
        }
      }
      if (!contains) {
        a.chave = event.snapshot.key;
        Apoios.add(a);
        inApoio.add(Apoios);
      }
    });
  }
}
