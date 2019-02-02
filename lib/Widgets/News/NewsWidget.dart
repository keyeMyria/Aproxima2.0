import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/News.dart';
import 'package:aproxima/Telas/UserProfile/friend_details_page.dart';
import 'package:aproxima/Widgets/News/NewsController.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgeteState createState() => new _NewsWidgeteState();
}

class _NewsWidgeteState extends State<NewsWidget> {
  NewsController nc;
  ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    nc = BlocProvider.of<NewsController>(context);
    return StreamBuilder(
      stream: nc.outNews,
      builder: (context, snap) {
        return Container(
          child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance
                  .reference()
                  .child(Helpers.user.id.toString())
                  .child('News'),
              shrinkWrap: true,
              duration: Duration(seconds: 1),
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              sort: (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key),
              controller: sc,
              itemBuilder: (context, snapshot, anim, index) {
                return buildNewsItem(
                    News.toJson(snapshot.value)); // buildComentarioItem();
              }),
        );
      },
    );
  }

  Widget buildNewsItem(News n) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FriendDetailsPage(n.Responsavel, false, 0, isuser: true),
              ));
        },
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
                'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'),
          ),
        ),
      ),
      new Padding(padding: EdgeInsets.only(right: 10)),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                  onTap: () {
                    nc.openNews(n, context);
                  },
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
                              new Padding(padding: EdgeInsets.only(top: 6)),
                              Text(
                                n.noticia,
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
                                        Helpers().readTimestamp(n.data),
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
                          )))))),
    ]);
  }
}
