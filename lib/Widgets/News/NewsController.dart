import 'dart:async';
import 'dart:convert';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/News.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class NewsController implements BlocBase {
  BehaviorSubject<String> _controllerNews = new BehaviorSubject<String>();

  StreamSubscription<String> controllerNews;
  DatabaseReference _newsRef = FirebaseDatabase.instance
      .reference()
      .child(Helpers.user.id.toString())
      .child('News');
  Stream<String> get outNews => _controllerNews.stream;

  Sink<String> get inNews => _controllerNews.sink;
  @override
  void dispose() {
    _controllerNews.close();
  }

  NewsController() {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    database
        .reference()
        .child(Helpers.user.id.toString())
        .child('News')
        .once()
        .then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  Future<Null> increment(News n) async {
    _newsRef.push().set(n.toMap()).then((d) {
      print('Foi');
    });
  }

  Future<void> openNews(News n, context) {
    print(n.toString());
    switch (n.tipo) {
      case 0:
        print('Entrou aqui case 0');
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
}
