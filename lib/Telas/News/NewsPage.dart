import 'package:aproxima/Widgets/News/NewsController.dart';
import 'package:aproxima/Widgets/News/NewsWidget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  NewsController nc = new NewsController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: Scaffold(
        body: Container(child: NewsWidget()),
        appBar: new AppBar(
          title: new Text(
            "Notificacões",
            style: new TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      ),
      bloc: nc,
    );
  }
}
