import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Telas/UserProfile/UserRelatosController.dart';
import 'package:aproxima/Widgets/FeedUtils/Feed.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserRelatos extends StatelessWidget {
  GlobalKey<ScaffoldState> key;

  UserRelatos({this.key});

  List<Widget> _buildItems() {
    var items = <Widget>[];

    for (var i = 1; i <= 6; i++) {
      var image = new Image.asset(
        'images/portfolio_$i.jpeg',
        width: 200.0,
        height: 200.0,
      );

      items.add(image);
    }

    return items;
  }

  List<Protocolo> itens;
  UserRelatosController urc;
  @override
  Widget build(BuildContext context) {
    bool meusDesejos = true;
    urc = BlocProvider.of<UserRelatosController>(context);
    return new Scaffold(
        body: StreamBuilder<List<Protocolo>>(
            stream: urc.outUserRelatos,
            builder: (BuildContext context,
                AsyncSnapshot<List<Protocolo>> snapshot) {
              if (snapshot.data != null) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: new ListView.builder(
                      itemBuilder: (context, index) {
                        return ActivityFeedItem(
                          protocolo: snapshot.data[index],
                          type: 'comment',
                        );
                      },
                      itemCount: snapshot.data.length,
                    ));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Carregando Dados',
                      style: TextStyle(color: Colors.green, fontSize: 32.0),
                    ),
                    SpinKitThreeBounce(
                      color: Colors.green,
                      size: 50.0,
                    )
                  ],
                );
              }
            }));
  }
}
