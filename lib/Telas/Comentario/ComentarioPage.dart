import 'dart:convert';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Comentario.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Telas/Comentario/ComentarioController.dart';
import 'package:aproxima/Telas/EditarProtocolo/EditarProtocolo.dart';
import 'package:aproxima/Telas/ProtocoloTop/UpdatePostTop.dart';
import 'package:aproxima/Telas/UpdateProtocolo/UpdateProtocolo.dart';
import 'package:aproxima/Telas/UserProfile/friend_details_page.dart';
import 'package:aproxima/Widgets/FeedUtils/Feed.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComentarioPage extends StatefulWidget {
  Protocolo p;
  ComentarioPage(this.p);

  _ComentarioPageState createState() => _ComentarioPageState();
}

class _ComentarioPageState extends State<ComentarioPage> {
  final TextEditingController _commentController =
      new TextEditingController(text: '');
  ScrollController sc;
  ComentarioController cpc;
  @override
  Widget build(BuildContext context) {
    print('Protocolo AQUI ${widget.p.toString()}');
    cpc = ComentarioController(widget.p);
    sc = new ScrollController();

    return StreamBuilder(
        stream: cpc.outProtocolo,
        builder: (context, AsyncSnapshot<Protocolo> snapProtocolo) {
          print('AQUI FDP UPDATES ${snapProtocolo.data.updates_protocolos}');
          return Scaffold(
            body: Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  snapProtocolo.data.updates_protocolos != null
                      ? UpdatePostTop(snapProtocolo.data.updates_protocolos,
                          snapProtocolo.data)
                      : Container(),
                  ActivityFeedItem(
                    protocolo: snapProtocolo.data,
                    hideComment: true,
                  ),
                  BlocProvider(
                    child: FirebaseAnimatedList(
                        query: FirebaseDatabase.instance
                            .reference()
                            .child('Protocolos')
                            .child(snapProtocolo.data.id.toString())
                            .child('Comentarios'),
                        shrinkWrap: true,
                        duration: Duration(seconds: 1),
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        sort: (DataSnapshot a, DataSnapshot b) =>
                            b.key.compareTo(a.key),
                        controller: sc,
                        itemBuilder: (context, snapshot, anim, index) {
                          return buildComentarioItem(Comentario.toJson(
                              snapshot.value)); // buildComentarioItem();
                        }),
                    bloc: cpc,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * .045),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                    color: Colors.grey[200],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .09,
                    margin: EdgeInsets.symmetric(horizontal: 7),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                        ),
                        Expanded(
                          flex: 100,
                          child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: _commentController,
                              maxLines: 1,
                              autocorrect: true,
                              enableInteractiveSelection: true,
                              keyboardAppearance: Brightness.dark,
                              onFieldSubmitted: (t) {
                                cpc.addComment(new Comentario(
                                    Helpers.user,
                                    null,
                                    DateTime.now(),
                                    _commentController.text,
                                    null));
                                _commentController.text = '';
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Diga algo sobre isso',
                                  contentPadding:
                                      new EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0)))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, left: 2, right: 3),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60.0),
                                border: Border.all(
                                    color: Colors.black87, width: 0.1)),
                            child: IconButton(
                              onPressed: () {
                                print('ChAMOU ON PRESSED');
                                cpc.addComment(new Comentario(
                                    Helpers.user,
                                    null,
                                    DateTime.now(),
                                    _commentController.text,
                                    null));
                                Helpers.fbmsg.subscribeToTopic(
                                    'protocoloteste' +
                                        snapProtocolo.data.id.toString());
                                Helpers.nh.sendNotification({
                                  'title':
                                      '${Helpers.user.nome} Comentou: ${_commentController.text} no Relato ${snapProtocolo.data.titulo}',
                                  'responsavel': json.encode(Helpers.user),
                                  'tipo': 0.toString(),
                                  'sujeito': snapProtocolo.data.id.toString(),
                                  'topic': 'protocoloteste' +
                                      snapProtocolo.data.id.toString(),
                                  'foto': Helpers.user.foto == null
                                      ? 'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'
                                      : Helpers.user.foto,
                                  'data': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                });

                                _commentController.text = '';
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                sc.animateTo(0,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.decelerate);
                                sc.attach(sc.position);
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.blue,
                              ),
                            )),
                        new Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                      ],
                    )),
              ),
            ]),
            appBar: new AppBar(
              actions: <Widget>[
                Helpers.user.id == snapProtocolo.data.user_id ||
                        Helpers.user.permissao >= 2
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditarProtocolo(snapProtocolo.data)));
                        },
                      )
                    : new Container(),
                Helpers.user.id == snapProtocolo.data.user_id ||
                        Helpers.user.permissao >= 2
                    ? IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          semanticLabel: 'Dar Andamento',
                        ),
                        onPressed: () {
                          AddUpdateProtocolo().showDialogUpdate(
                              snapProtocolo.data, context, cpc);
                        },
                      )
                    : new Container()
              ],
              title: new Text(
                snapProtocolo.data.titulo,
                style: new TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        });
  }

  Widget buildComentarioItem(Comentario c) {
    if (Helpers.user.id == c.criador.id) {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        new Padding(padding: EdgeInsets.only(right: 10)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendDetailsPage(c.criador, false, 0,
                      avatarTag: c.comentario + c.criador.id.toString(),
                      isuser: true),
                ));
          },
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
                'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'),
          ),
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 4)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FriendDetailsPage(
                                          c.criador, false, 0,
                                          avatarTag: c.comentario +
                                              c.criador.id.toString(),
                                          isuser: true),
                                    ));
                              },
                              child: Text(
                                c.criador.nome,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 6)),
                            Text(
                              c.comentario,
                              style: TextStyle(fontSize: 14),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Helpers().readTimestamp(c.created_at),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                )),
                            new Divider(),
                          ],
                        )))))
      ]);
    } else {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 4)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FriendDetailsPage(
                                          c.criador, false, 0,
                                          avatarTag: c.comentario +
                                              c.criador.id.toString(),
                                          isuser: true),
                                    ));
                              },
                              child: Text(
                                c.criador.nome,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 6)),
                            Text(
                              c.comentario,
                              style: TextStyle(fontSize: 14),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 8)),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Helpers().readTimestamp(c.created_at),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                )),
                            new Divider(),
                          ],
                        ))))),
        new Padding(padding: EdgeInsets.only(left: 10)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendDetailsPage(c.criador, false, 0,
                      avatarTag: c.comentario + c.criador.id.toString(),
                      isuser: true),
                ));
          },
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
                'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'),
          ),
        ),
      ]);
    }
  }
}
