import 'dart:async';

import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/UserProfile/UserEdit/UserEdit.dart';
import 'package:aproxima/Telas/UserProfile/UserRelatosController.dart';
import 'package:aproxima/Telas/UserProfile/footer/friend_detail_footer.dart';
import 'package:aproxima/Telas/UserProfile/friend_detail_body.dart';
import 'package:aproxima/Telas/UserProfile/header/friend_detail_header.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class FriendDetailsPage extends StatefulWidget {
  FriendDetailsPage(
    this.user,
    this.fromMain,
    this.qtdeDesejos, {
    this.avatarTag,
    this.isuser,
  });

  final bool fromMain;
  final bool isuser;
  final User user;
  final Object avatarTag;
  final int qtdeDesejos;

  @override
  _FriendDetailsPageState createState() => new _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  Future<bool> _onWillPop() {
    Navigator.of(context).pop();

    return new Future.value(false);
  }

  UserRelatosController urc;
  @override
  Widget build(BuildContext context) {
    urc = UserRelatosController(widget.user.id.toString());
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[Colors.green, Colors.white],
      ),
    );

    return new Scaffold(
      appBar: widget.isuser
          ? AppBar(
              leading: IconButton(
                  icon: Icon(Icons.mode_edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserEdit(widget.user)));
                  }),
              elevation: 0,
              bottomOpacity: 1,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {},
                ),
              ],
            )
          : AppBar(
              elevation: 0,
              bottomOpacity: 1,
              actions: <Widget>[],
            ),
      body: BlocProvider(
        child: new SingleChildScrollView(
          child: new Container(
            decoration: linearGradient,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new FriendDetailHeader(
                    widget.user,
                    widget.qtdeDesejos,
                    avatarTag:
                        widget.avatarTag != null ? widget.avatarTag : null,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 0),
                  child: new FriendDetailBody(widget.user),
                ),
                new FriendShowcase(widget.user),
              ],
            ),
          ),
        ),
        bloc: urc,
      ),
    );
  }
}
