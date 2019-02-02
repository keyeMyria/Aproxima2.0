import 'dart:async';
import 'dart:io';

import 'package:aproxima/Helpers/Choise.dart';
import 'package:aproxima/Helpers/CustomSearchBar.dart';
import 'package:aproxima/Helpers/radialmenu/src/radial_menu.dart';
import 'package:aproxima/Helpers/radialmenu/src/radial_menu_item.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Telas/Mapa/MapaController.dart';
import 'package:aproxima/Widgets/PaginaPrincipal/PaginaPrincipalPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong/latlong.dart';
import 'package:unicorndial/unicorndial.dart';

enum MenuOptions {
  unread,
  share,
  archive,
  delete,
  backup,
  copy,
}

///This API Key will be used for both the interactive maps as well as the static maps.
///Make sure that you have enabled the following APIs in the Google API Console (https://console.developers.google.com/apis)
/// - Static Maps API
/// - Android Maps API
/// - iOS Maps API
const API_KEY = "AIzaSyAb3PUEzMj_4866UdNCLgrewCPR8w4Pcok";

class Mapa extends StatefulWidget {
  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<Mapa> {
  MapaController mapc = MapaController();

  var compositeSubscription = new CompositeSubscription();
  Uri staticMapUri;
  CustomSearchBar searchBar;

  static double size = 35.0;

  //Line

  @override
  initState() {
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

  Choice _selectedChoice = MenuPrincipal[0]; // The app's "state".
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

  UnicornDialer ud;

  final List<RadialMenuItem<MenuOptions>> items = <RadialMenuItem<MenuOptions>>[
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.delete,
      size: size,
      child: new Icon(
        Icons.my_location,
      ),
      iconColor: Colors.black,
      backgroundColor: Colors.white,
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.backup,
      size: size,
      child: new Icon(
        Icons.filter_list,
      ),
      iconColor: Colors.black,
      backgroundColor: Colors.white,
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.copy,
      child: new Icon(
        Icons.map,
      ),
      iconColor: Colors.black,
      size: size,
      backgroundColor: Colors.white,
    ),
    new RadialMenuItem<MenuOptions>(
      value: MenuOptions.copy,
      child: new Icon(
        Icons.send,
      ),
      iconColor: Colors.black,
      size: size,
      backgroundColor: Colors.white,
    ),
  ];

  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();
  void _onItemSelected(MenuOptions value) {
    print('AQUI LOLOLo' + value.toString());
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
            key: _scaffoldKey,
            appBar: searchBar.build(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: new GestureDetector(
                onTap: () {
                  print('lalala');
                },
                child: new RadialMenu(
                  key: _menuKey,
                  items: items,
                  radius: MediaQuery.of(context).size.width * 0.2,
                  onSelected: _onItemSelected,
                )),
            body: StreamBuilder(
                stream: mapc.outMapa,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        child: new FlutterMap(
                      options: new MapOptions(
                        interactive: true,
                        onTap: (ll) {},
                        center: new LatLng(-24.5, -50.4),
                        zoom: 13.0,
                      ),
                      mapController: MapController(),
                      layers: [
                        new TileLayerOptions(
                          urlTemplate: "https://api.tiles.mapbox.com/v4/"
                              "{id}/{z}/{x}/{y}@2x.png?access_token=sk.eyJ1IjoicmJzb2Z0d2FyZSIsImEiOiJjam5xYng1aG8wMG55M3hreXJlZmVxMjA1In0.NBY7xfp9rERgMM3Ub1iwFg",
                          additionalOptions: {
                            'accessToken':
                                'sk.eyJ1IjoicmJzb2Z0d2FyZSIsImEiOiJjam5xYng1aG8wMG55M3hreXJlZmVxMjA1In0.NBY7xfp9rERgMM3Ub1iwFg',
                            'id': 'mapbox.streets',
                          },
                        ),
                        new MarkerLayerOptions(
                          markers: [
                            new Marker(
                                width: 80.0,
                                height: 80.0,
                                point: new LatLng(-24.5, -50.4),
                                builder: (ctx) => new GestureDetector(
                                      onTap: () {
                                        showSnackBar();
                                      },
                                      child: new Container(
                                        child: new Icon(
                                          Icons.place,
                                          size: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
                                          color: Colors.red,
                                        ),
                                      ),
                                    )),
                          ],
                        ),
                      ],
                    ));
                  } else {
                    mapc.Fetch();
                    return Container();
                  }
                })),
        onWillPop: _willPop);
  }

  List<Marker> criarMarkers(List<Protocolo> protocolos) {
    List<Marker> markers;
    for (Protocolo p in protocolos) {
      markers.add(new Marker(point: LatLng(p.lat, p.lng)));
    }
    return List<Marker>();
  }

  showSnackBar() {
    final snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: new Container(
            height: MediaQuery.of(context).size.height * 0.49,
            color: Colors.transparent,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  'Buraco na Rua',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22.0),
                                ),
                              ),
                              new ActionChip(
                                onPressed: () {},
                                label: Icon(
                                  Icons.share,
                                  color: Colors.green,
                                ),
                                backgroundColor: Colors.white,
                              ),
                              new Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                              ),
                              new ActionChip(
                                onPressed: () {},
                                label: Icon(
                                  Icons.notifications_active,
                                  color: Colors.green,
                                ),
                                backgroundColor: Colors.white,
                              ),
                              new Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                              ),
                              new ActionChip(
                                onPressed: () {},
                                label: Icon(
                                  Icons.send,
                                  color: Colors.green,
                                ),
                                backgroundColor: Colors.white,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Text('Precisamos Arrumar este buraco urgente!!',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              )),
                        ],
                      )),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                    imageUrl:
                        'http://s2.glbimg.com/4vFOVs8YjaF_P4pqUcMNxz8IbTU=/620x465/s.glbimg.com/jo/g1/f/original/2014/01/02/467f44c8cc55b9dfa391c9b1abb9c58b.jpg',
                    placeholder: SpinKitFoldingCube(
                      color: Colors.green,
                      size: 50.0,
                    )),
              ],
            )));

// Find the Scaffold in the Widget tree and use it to show a SnackBar
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showStatuses() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Status"),
          content: Column(
            children: Statuses(),
          ),
        );
      },
    );
  }

  List<Widget> Statuses() {
    List<Widget> statuses = new List();
    for (Choice choice in StatusChoises) {
      statuses.add(
        new GestureDetector(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(choice.icon, color: choice.color),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(choice.title,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ))),
              ],
            ),
          ),
          onTap: () {},
        ),
      );
    }
    return statuses;
  }

  Future<bool> _willPop() {
    exit(0);
  }
}

class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}
