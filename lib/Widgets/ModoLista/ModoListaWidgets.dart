import 'package:aproxima/Helpers/Choise.dart';
import 'package:aproxima/Helpers/CustomSearchBar.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Widgets/FeedUtils/Feed.dart';
import 'package:aproxima/Widgets/ModoLista/ModoListaController.dart';
import 'package:aproxima/Widgets/PaginaPrincipal/PaginaPrincipalPage.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ModoListaWidget extends StatefulWidget {
  @override
  _ModoListaWidgetState createState() => _ModoListaWidgetState();
}

class _ModoListaWidgetState extends State<ModoListaWidget> {
  ModoListaController mlc = ModoListaController();
  CustomSearchBar searchBar;

  @override
  initState() {
    {
      super.initState();
      searchBar = new CustomSearchBar(
          leading: Text(''),
          onClosed: () {},
          inBar: true,
          showClearButton: false,
          setState: setState,
          onSubmitted: print,
          buildDefaultAppBar: buildAppBar);
    }
    // TODO: implement initState
    super.initState();
  }

  String x = 'a';

  Widget build(BuildContext context) {
    final ModoListaController mlc =
        BlocProvider.of<ModoListaController>(context);
    return new Scaffold(
        appBar: searchBar.build(context),
        body: StreamBuilder<List<Protocolo>>(
            stream: mlc.outModoLista,
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

  Widget _footerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: 'Carregando...',
      idleIcon: const Icon(Icons.arrow_upward),
      idleText: 'Mais...',
      noDataText: 'Fim dos Relatos',
    );
  }

  Choice _selectedChoice = MenuPrincipal[0];
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      if (choice.title == "Lista") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModoListaPage(),
            ));
      }
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('AproximA+'),
        leading: searchBar.getSearchAction(context),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {},
          ),
          PopupMenuButton<Choice>(
            icon: Icon(Icons.filter_list),
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return MenuPrincipal.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: ChoiceCard(
                      choice: choice,
                    ));
              }).toList();
            },
          ),
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return MenuPrincipal.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: ChoiceCard(
                      choice: choice,
                    ));
              }).toList();
            },
          ),
        ]);
  }
}
