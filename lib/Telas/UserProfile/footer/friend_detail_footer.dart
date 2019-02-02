import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/UserProfile/footer/portfolio_showcase.dart';
import 'package:flutter/material.dart';

class FriendShowcase extends StatefulWidget {
  FriendShowcase(this.friend);

  final User friend;

  @override
  _FriendShowcaseState createState() => new _FriendShowcaseState();
}

class _FriendShowcaseState extends State<FriendShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'Relatos'),
      // new Tab(text: 'Amigos'),
      // new Tab(text: 'Conquistas'),
    ];
    _pages = [
      new UserRelatos(key: widget.key),
      // new SkillsShowcase(),
      //   new ArticlesShowcase(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.white,
          ),
          new SizedBox.fromSize(
            size: MediaQuery.of(context).size,
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    ));
  }
}
