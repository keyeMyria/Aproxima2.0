import 'package:aproxima/Helpers/Helpers.dart';
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
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: new Text(
            "Notificações",
            style: new TextStyle(color: Helpers.blue_default),
          ),
        ),
      ),
      bloc: nc,
    );
  }
}
