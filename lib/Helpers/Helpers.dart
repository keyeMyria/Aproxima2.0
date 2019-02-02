import 'dart:async';
import 'dart:convert';

import 'package:aproxima/Helpers/NotificacoesHelper.dart';
import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Estado.dart';
import 'package:aproxima/Objetos/Pais.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Helpers {
  static bool isVisivel;
  static bool acaoVoto;
  static User user;
  static String appBadgeSupported;
  SharedPreferences prefs;
  static NotificacoesHelper nh = new NotificacoesHelper();
  static List<CameraDescription> cameras;

  static User aproximaUser = new User.withFoto(
      0,
      'AproximA+',
      '',
      '',
      '',
      '',
      '',
      DateTime.now(),
      0,
      5,
      DateTime.now(),
      DateTime.now(),
      null,
      '',
      null,
      null,
      '');

  static BuildContext zoomContext;
 // static CacheManager cacheManager;

  Cidade tibagi = new Cidade('Tibagi', 1, 0, -24.6883256, -50.6186093,
      new Estado('Paraná', 0, 'PR', 0, new Pais(0, 'Brasil', 'BR')));

  static Color getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  /*Future<Usuario> AtualizarToken(Usuario u) async {
    print('Entrou ATT Token');
    print(token);
    if (token == null) {
      print('entrou aqui');
      token = await fbmsg.getToken();
      print(token);
    }

    if (u.token == null) {
      u.token = token;

      return Firestore.instance
          .collection('usuarios')
          .document(u.uid)
          .updateData(u.toJson())
          .then((va) {
        print('Token Atualizado' + u.uid + u.token);
        return u;
      });
    } else {
      if (u.token != token) {
        u.token = token;

        return Firestore.instance
            .collection('usuarios')
            .document(u.uid)
            .updateData(u.toJson())
            .then((va) {
          print('Token Atualizado' + u.uid + u.token);
          return u;
        });
      } else {
        return new Future(() {
          return u;
        });
      }
    }
  }*/


  Map<String, dynamic> getmapListDynamic(Map<dynamic, dynamic> d) {
    Map<String, dynamic> s = new Map();
    void iterateMapEntry(key, value) {
      if (value != null) {
        s[key.toString()] = value;
      } else {
        s[key.toString()] = '';
      }
    }

    d.forEach(iterateMapEntry);
    return s;
  }

  /*static int buscarQuantidadeDesejos(Usuario friend) {
    print("BuscarQuantidadeDesejosMETODO");
    int val = 0;
    Firestore.instance
        .collection("desejos")
        .where("uid", isEqualTo: friend.uid)
        .getDocuments()
        .then((docs) {
      int d = docs.documents.asMap().length;
      print("BuscarQuantidadeDesejos");
      print(d);

      val = d;
    });
    return val;
  }
*/
  static SlidableDelegate getDelegate(int index) {
    switch (index % 4) {
      case 0:
        return new SlidableBehindDelegate();
      case 1:
        return new SlidableStrechDelegate();
      case 2:
        return new SlidableScrollDelegate();
      case 3:
        return new SlidableDrawerDelegate();
      default:
        return null;
    }
  }

  /*setLud() {
    Firestore.instance
        .collection('usuarios_desejos')
        .where('usuario', isEqualTo: fbUser.uid)
        .getDocuments()
        .then((v) {
      List<UsuariosDesejo> lud = new List();
      for (var ud in v.documents) {
        UsuariosDesejo udd = new UsuariosDesejo(ud['id_desejo'] as String,
            ud['situacao'] as String, ud['usuario'] as String);
        udd.key = ud.documentID;
        lud.add(udd);
      }
      listud = lud;
    });
  }*/

  /*FilterDesejos(List<Desejo> des) {
    //print('Entrou Filter ' + des.toString());
    if (listud != null) {
      List<UsuariosDesejo> lud = new List();
      for (UsuariosDesejo ud in listud) {
        lud.add(ud);
      }
      List<Desejo> desejos = new List();
      for (Desejo d in des) {
        if (d.dataPretendida.microsecondsSinceEpoch >
            DateTime.now().microsecondsSinceEpoch) {
          bool hasAction = false;
          for (UsuariosDesejo u in lud) {
            if (u.id_desejo == d.key) {
              if (u.situacao != 'later') {
                hasAction = true;
              }
            }
          }
          bool ageMatche = true;
          bool UserInDesejo = false;
          for (Usuario u in d.participantes) {
            if (u.uid == Helpers.fbUser.uid) {
              UserInDesejo = true;
            }
            DateTime agora = DateTime.now();
            DateTime minima = new DateTime(
                agora.year - Helpers.fbUser.minAge.floor(),
                agora.month,
                agora.day);
            DateTime maxima = new DateTime(
                agora.year - Helpers.fbUser.maxAge.floor(),
                agora.month,
                agora.day);
            if (u.idade.microsecondsSinceEpoch >
                minima.microsecondsSinceEpoch) {
              ageMatche = false;
            }
            if (u.idade.microsecondsSinceEpoch <
                maxima.microsecondsSinceEpoch) {
              ageMatche = false;
            }
          }
          /*print('Desejo Has Action' +
              hasAction.toString() +
              'ageMatche' +
              ageMatche.toString() +
              ' Desejo ' +
              d.toString());*/
          if (!hasAction && ageMatche && !UserInDesejo) {
            desejos.add(d);
          }
        }
      }
      if (desejos.length == 0) {
        return null;
      } else {
        return desejos;
      }
    } else {
      return null;
    }
  }*/

  Helpers() {}
  Future Start() async {
    prefs = await SharedPreferences.getInstance();
  }

  String mapToQuery(Map<String, dynamic> map, {Encoding encoding}) {
    map.keys
        .where((k) => (map[k] == null))
        .toList() // -- keys for null elements
        .forEach(map.remove);
    var pairs = <List<String>>[];
    map.forEach((key, value) => pairs.add([
          Uri.encodeQueryComponent(key),
          Uri.encodeQueryComponent(value.toString())
        ]));

    return pairs.map((pair) => "${pair[0]}=${pair[1]}").join("&");
  }

  /*Desejo getDesejo() {
    //print("VEIO" + prefs.getString('Desejo'));
    Desejo d = Desejo.fromJson(
        json.decode(prefs.getString('Desejo').replaceAll("Desejo", '')));
    //print("Desejo lolol" + d.toString());
    return d;
  }*/

  String readTimestamp(DateTime date) {
    //TODO Tirar o -50000000
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(date, locale: 'pt_BR');
  }

  /*setDesejo(Desejo d) {
    //print('Gravando' + d.toString());
    prefs.setString("Desejo", d.toString());
  }*/

  static String token;

  static FirebaseMessaging fbmsg;

  //static UsuariosDesejo IniciarNovoChat;

  void MapsToString(Map<String, dynamic> d) {
    void Saver(key, value) {
      d[key] = value;
    }

    d.forEach(Saver);
  }
}
