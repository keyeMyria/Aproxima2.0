import 'dart:async';
import 'dart:io';

import 'package:aproxima/Helpers/Choise.dart';
import 'package:aproxima/Helpers/CustomSearchBar.dart';
import 'package:aproxima/Helpers/Drawer.dart';
import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Helpers/radialmenu/src/radial_menu.dart';
import 'package:aproxima/Helpers/radialmenu/src/radial_menu_item.dart';
import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Secretaria.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:aproxima/Telas/Mapa/MapaController.dart';
import 'package:aproxima/Telas/Mapa2/ControllerSnackBar.dart';
import 'package:aproxima/Telas/UserProfile/friend_details_page.dart';
import 'package:aproxima/Widgets/FeedUtils/Bolinhas.dart';
import 'package:aproxima/Widgets/FeedUtils/FotoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
  static const String route = 'on_tap';

  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<Mapa> {
  MapaController mapc = MapaController();

  var compositeSubscription = new CompositeSubscription();
  Uri staticMapUri;
  CustomSearchBar searchBar;
  var mapController = MapController();

  static double size = 35.0;

  //Line

  @override
  initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  Choice _selectedChoice = MenuPrincipal[0]; // The app's "state".

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text(Helpers.user.cidade.cidade);
  FocusNode myFocusNode;

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
            drawer: buildDrawer(context, Mapa.route),
            appBar: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * .1),
                child: StreamBuilder(
                    stream: mapc.outIsFiltering,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return new AppBar(
                            title: snap.data
                                ? new TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: _filter,
                                    focusNode: myFocusNode,
                                    onEditingComplete: () {
                                      mapc.UpdateFilter(true);
                                      mapc.StartFilter(
                                        filtertext: _filter.text,
                                      );
                                    },
                                    onSubmitted: (s) {
                                      mapc.UpdateFilter(true);
                                      mapc.StartFilter(
                                        filtertext: _filter.text,
                                      );
                                    },
                                    decoration: new InputDecoration(
                                        suffixIcon: new IconButton(
                                            icon: Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              mapc.UpdateFilter(true);
                                              mapc.StartFilter(
                                                filtertext: _filter.text,
                                              );
                                            }),
                                        hintText: 'Procurar...',
                                        hintStyle:
                                            TextStyle(color: Colors.white)),
                                  )
                                : new Text(Helpers.user.cidade.cidade),
                            leading: IconButton(
                                icon: snap.data
                                    ? Icon(Icons.close)
                                    : Icon(Icons.search),
                                onPressed: () {
                                  if (snap.data == true) {
                                    filteredNames = names;
                                    _filter.clear();
                                    mapc.UpdateFilter(false);
                                    mapc.StartFilter();
                                  } else {
                                    mapc.inIsFiltering.add(true);
                                  }
                                }),
                            actions: [
                              StreamBuilder(builder: (context, snap) {
                                return IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () async {
                                    final List<DateTime> picked =
                                        await DateRagePicker.showDatePicker(
                                            context: context,
                                            initialFirstDate:
                                                new DateTime.now(),
                                            initialLastDate:
                                                (new DateTime.now())
                                                    .add(new Duration(days: 7)),
                                            firstDate: new DateTime(2015),
                                            lastDate: new DateTime(2020));
                                    if (picked != null && picked.length == 2) {
                                      mapc.UpdateFilterByDate(true);
                                      mapc.StartFilter(
                                          d1: picked[0], d2: picked[1]);
                                    }
                                  },
                                );
                              }),
                              PopupMenuButton<Choice>(
                                icon: Icon(Icons.filter_list),
                                onSelected: (choise) {
                                  mapc.UpdateFilterByStatus(true);
                                  mapc.StartFilter(c: choise);
                                },
                                itemBuilder: (BuildContext context) {
                                  return StatusChoises.map((Choice choice) {
                                    return PopupMenuItem<Choice>(
                                        value: choice,
                                        child: ChoiceCard(
                                          choice: choice,
                                        ));
                                  }).toList();
                                },
                              ),
                              StreamBuilder(
                                  stream: mapc.outSecretarias,
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      return PopupMenuButton<Secretaria>(
                                        icon: Icon(Icons.local_printshop),
                                        onSelected: (choise) {
                                          mapc.UpdateFilterBySecretaria(true);
                                          mapc.StartFilter(s: choise);
                                        },
                                        itemBuilder: (BuildContext context) {
                                          List<PopupMenuItem<Secretaria>>
                                              itens = new List();
                                          for (Secretaria s in snap.data) {
                                            itens.add(PopupMenuItem<Secretaria>(
                                              value: s,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(s.nome),
                                              ),
                                            ));
                                          }
                                          return itens;
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                            ]);
                      } else {
                        return Container();
                      }
                    })),
            body: StreamBuilder(
                stream: mapc.outMapa,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        child: Stack(
                      children: <Widget>[
                        new FlutterMap(
                          options: new MapOptions(
                            interactive: true,
                            onTap: (ll) {},
                            center: new LatLng(Helpers.user.cidade.lat,
                                Helpers.user.cidade.lng),
                            zoom: 13.0,
                          ),
                          mapController: mapController,
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
                            new PolylineLayerOptions(polylines: [
                              new Polyline(
                                  points: getCityPoints(Helpers.user.cidade),
                                  strokeWidth: 5.0,
                                  color: Colors.red)
                            ]),
                            new MarkerLayerOptions(
                                markers: criarMarkers(snapshot.data)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.info),
                              color: Colors.blueAccent,
                              onPressed: () {
                                mapc.outshowFilters.first.then((b) {
                                  mapc.UpdateShowFilters(!b);
                                });
                              },
                            ),
                            StreamBuilder(
                              initialData: false,
                              stream: mapc.outshowFilters,
                              builder: (context, s) {
                                if (s.hasData) {
                                  if (s.data) {
                                    return Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            color: Color.fromARGB(
                                                60, 160, 160, 160),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .35,
                                            child: ListView.builder(
                                                itemCount: 6,
                                                itemBuilder: (context, index) {
                                                  switch (index) {
                                                    case 0:
                                                      return Text(
                                                          'Relatos: ${snapshot.data.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16));
                                                    case 1:
                                                      return StreamBuilder(
                                                        stream:
                                                            mapc.outIsFiltering,
                                                        initialData: false,
                                                        builder:
                                                            (context, snap) {
                                                          if (snap.hasData) {
                                                            if (snap.data &&
                                                                mapc.filtertext !=
                                                                    '') {
                                                              return Text(
                                                                  'Palavra chave: ${mapc.filtertext}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16));
                                                            } else {
                                                              return Container();
                                                            }
                                                          } else {
                                                            return Container();
                                                          }
                                                        },
                                                      );
                                                    case 2:
                                                      return StreamBuilder(
                                                        stream: mapc
                                                            .outIsFilteringByDate,
                                                        initialData: false,
                                                        builder:
                                                            (context, snap) {
                                                          if (s.hasData) {
                                                            if (snap.data) {
                                                              return Text(
                                                                  'De:   ${mapc.d1.day} /${mapc.d1.month}/${mapc.d1.year} A:  ${mapc.d2.day} /${mapc.d2.month}/${mapc.d2.year}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16));
                                                            } else {
                                                              return Container();
                                                            }
                                                          } else {
                                                            return Container();
                                                          }
                                                        },
                                                      );
                                                    case 3:
                                                      return StreamBuilder(
                                                        stream: mapc
                                                            .outisFilteringByStatus,
                                                        initialData: false,
                                                        builder:
                                                            (context, snap) {
                                                          if (snap.hasData) {
                                                            if (snap.data) {
                                                              if (mapc.c !=
                                                                  null) {
                                                                return Text(
                                                                    'Status:   ${mapc.c.title}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16));
                                                              } else {
                                                                return Container();
                                                              }
                                                            } else {
                                                              return Container();
                                                            }
                                                          } else {
                                                            return Container();
                                                          }
                                                        },
                                                      );
                                                    case 4:
                                                      return StreamBuilder(
                                                        stream: mapc
                                                            .outisFilteringBySecretaria,
                                                        initialData: false,
                                                        builder:
                                                            (context, snap) {
                                                          if (snap.hasData) {
                                                            if (snap.data) {
                                                              return Text(
                                                                  'Status:   ${mapc.s.nome}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16));
                                                            } else {
                                                              return Container();
                                                            }
                                                          } else {
                                                            return Container();
                                                          }
                                                        },
                                                      );
                                                    case 5:
                                                      return MaterialButton(
                                                        child: Text(
                                                          'Limpar Filtros',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color:
                                                            Colors.blueAccent,
                                                        onPressed: () {
                                                          mapc.UpdateFilterBySecretaria(
                                                              false);
                                                          mapc.UpdateFilter(
                                                              false);
                                                          mapc.UpdateFilterByStatus(
                                                              false);
                                                          mapc.UpdateFilterByDate(
                                                              false);
                                                          mapc.UpdateShowFilters(
                                                              false);
                                                          mapc.StartFilter();
                                                        },
                                                      );
                                                  }
                                                })));
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            )
                          ],
                        )
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
    List<Marker> markers = new List();
    for (Protocolo p in protocolos) {
      markers.add(
        new Marker(
            width: 45.0,
            height: 45.0,
            point: new LatLng(p.lat, p.lng),
            builder: (ctx) => Container(
                child: IconButton(
                    onPressed: () {
                      print('CLICOU');
                      _showDialog(p);
                    },
                    icon: Icon(
                      Icons.place,
                      color: getStatus(p.status.descricao),
                    )))),
      );
    }
    return markers;
  }

  ControllerSnackBar csb;

  Widget TopArea(Protocolo post, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 5.0, 15, 5),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendDetailsPage(
                            post.usuario, false, 0,
                            avatarTag:
                                post.usuario.id.toString() + post.id.toString(),
                            isuser: false)));
              },
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: CachedNetworkImageProvider(
                  post.usuario.foto,
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Text(
                      post.usuario.nome,
                      maxLines: 3,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 5.0),
                child: Text(
                  post.cidade.cidade,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
            ],
          ),
          getStatusWidget(post.status.descricao, context),
        ],
      ),
    );
  }

  Widget getStatusWidget(String status, BuildContext context) {
    Color c;
    //print('Status: ${status}');
    switch (status) {
      case 'Em Andamento':
        c = Colors.lightBlueAccent;
        break;

      case 'Enviado':
        c = Colors.yellowAccent;
        break;

      case 'Encaminhado':
        c = Colors.orangeAccent;
        break;

      case 'Concluído':
        c = Colors.greenAccent;
        break;

      case 'Excluído':
        c = Colors.red;
        break;
    }
    return Expanded(
        child: GestureDetector(
            onTap: () {
              print('Click Snackbar');
              SnackBar s = SnackBar(
                content: Text(
                  'Status: ${status}',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: c,
              );
              Scaffold.of(context).showSnackBar(s);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      border: Border.all(
                          color: c, width: 1.0, style: BorderStyle.solid),
                    ),
                  )
                ])));
  }

  Widget actionColumn(Protocolo post, BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.blue[500],
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline),
                  color: Colors.blue[500],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComentarioPage(post)));
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                post.titulo,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: getTagss(post.tags),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, bottom: 4),
                child: Text(post.descricao,
                    maxLines: 999,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ))),
          ],
        ));
  }

  void _showDialog(Protocolo pr) {
    // ignore: undefined_method]
    Widget item;
    if (csb == null) {
      csb = new ControllerSnackBar(pr);
    } else {
      csb.inProtocolo.add(pr);
    }
    item = StreamBuilder(
        stream: csb.outProtocolo,
        builder: (context, snap) {
          if (snap.hasData) {
            Protocolo p = snap.data;
            if (p.fotos == null) {
              return Container(
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TopArea(p, context),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(), //profileColumn(context, post),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 2),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                color: Colors.blue[500],
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.chat_bubble_outline),
                                color: Colors.blue[500],
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ComentarioPage(p)));
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Text(
                              p.titulo,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                children: getTagss(p.tags),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ));
            } else {
              BolinhasController bc = new BolinhasController(p.fotos.length, 0);
              return Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(), //profileColumn(context, post),
                          ),
                          TopArea(p, context),
                          actionColumn(p, context),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .4,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(children: <Widget>[
                                Swiper(
                                    onIndexChanged: (newindex) {
                                      bc.inSelecionado.add(newindex);
                                    },
                                    itemCount: p.fotos.length,
                                    itemWidth:
                                        MediaQuery.of(context).size.width,
                                    layout: SwiperLayout.DEFAULT,
                                    itemHeight:
                                        MediaQuery.of(context).size.height * .4,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext c, int i) {
                                      return p.fotos[i].link != null
                                          ? Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                FotoPage(
                                                                    fotos:
                                                                        p.fotos,
                                                                    index: i),
                                                          ));
                                                    },
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .4,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            p.fotos[i].link,
                                                        placeholder:
                                                            SpinKitThreeBounce(
                                                          color: Colors.blue,
                                                          size: 50,
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )),
                                              ],
                                            )
                                          : Image.asset(
                                              'assets/logo.png',
                                              fit: BoxFit.fill,
                                            );
                                    }),
                                Positioned(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    bottom: 15.0,
                                    child: Center(
                                      child: StreamBuilder(
                                        builder: ((context, total) {
                                          return StreamBuilder(
                                              stream: bc.outSelecionado,
                                              builder: ((context, selecionado) {
                                                if (selecionado.hasData) {
                                                  return Center(
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: dotList(
                                                              total.data,
                                                              selecionado
                                                                  .data)));
                                                } else {
                                                  return Container();
                                                }
                                              }));
                                        }),
                                        stream: bc.outTotal, //,
                                      ),
                                    )),
                              ])),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                  ));
            }
          } else {
            return new Container(
              width: 1,
              height: 1,
            );
          }
        });
    showModalBottomSheet(
        builder: (context) {
          return Container(
              color: Colors.white,
              child: item,
              width: MediaQuery.of(context).size.width);
        },
        context: context);
    /*if (!isShown) {
      Scaffold.of(context).showSnackBar(showingSnackbar).closed.then((reason) {
        print('Snackbar dismissed reason: ${reason}');
        isShown = false;
      });
      isShown = true;
      Future.delayed(Duration(seconds: 35)).then((v) {
        isShown = false;
      });
    }*/
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  dotList(int length, int selecionado) {
    List<Widget> l = new List();
    for (int i = 0; i < length; i++) {
      l.add(Container(
        height: 15.0,
        width: 15.0,
        decoration: BoxDecoration(
          color: i == selecionado ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
              color: Colors.blue, width: 1.0, style: BorderStyle.solid),
        ),
      ));
    }
    return l;
  }

  getTagss(List<Tagss> tags) {
    List<Widget> l = new List();
    for (int i = 0; i < tags.length; i++) {
      l.add(Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            '#' + tags[i].tag.tag_nome,
            style:
                TextStyle(fontStyle: FontStyle.italic, color: Colors.blue[900]),
          ),
        ),
      ));
    }
    return l;
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

  Color getStatus(String status) {
    Color c;
    //print('Status: ${status}');
    switch (status) {
      case 'Em Andamento':
        c = Colors.lightBlueAccent;
        break;

      case 'Enviado':
        c = Colors.yellowAccent;
        break;

      case 'Encaminhado':
        c = Colors.orangeAccent;
        break;

      case 'Concluído':
        c = Colors.greenAccent;
        break;

      case 'Excluído':
        c = Colors.red;
        break;
    }
    return c;
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

  getCityPoints(Cidade cidade) {
    List<LatLng> points = new List();
    switch (cidade.id_cidade) {
      case 0:
        //Castro
        String s =
            "-50.13478879426185,-24.54105530745717,0 -50.09752214746746,-24.57958093966205,0 -50.08765389649177,-24.5818871712739,0 -50.08418374482066,-24.58621583104159,0 -50.08336892949815,-24.60073342811727,0 -50.07807427958235,-24.60443396435504,0 -50.07603905315759,-24.60134239230327,0 -50.06628983621112,-24.59980748061306,0 -50.0521557755287,-24.61151299974004,0 -50.05095840209646,-24.62144008041634,0 -50.04587934899745,-24.62519723025028,0 -50.03197538572847,-24.6276511848447,0 -50.0251714106826,-24.62241970911462,0 -50.02250614071496,-24.62365545160528,0 -49.99273719357227,-24.64586615997503,0 -49.98300511357614,-24.63208511960207,0 -49.9727494267314,-24.62840070728821,0 -49.97007917628244,-24.61253635488265,0 -49.95991763536392,-24.61052842405581,0 -49.95975735110341,-24.61050520081883,0 -49.93948946312101,-24.62625524740496,0 -49.93242529562311,-24.62130408860837,0 -49.92362964408254,-24.59894432014959,0 -49.91613420442562,-24.59127530062363,0 -49.9099968868515,-24.59018971481012,0 -49.91082090170404,-24.58414012978078,0 -49.8938055301832,-24.57938527938778,0 -49.88067284196306,-24.5693523486579,0 -49.87446657802692,-24.58820291441,0 -49.86111702883594,-24.59113942752165,0 -49.85297717256734,-24.58732084610973,0 -49.84280832060514,-24.59057110980558,0 -49.82601601947972,-24.60888247560031,0 -49.81995051696983,-24.59586587080631,0 -49.8110898294409,-24.59422950320291,0 -49.78461546038707,-24.60007607777455,0 -49.78276451411437,-24.59803542212476,0 -49.74819542666229,-24.60637390246096,0 -49.73790329833691,-24.60360250432494,0 -49.73179658737208,-24.61067770406912,0 -49.72043587048857,-24.61061972430084,0 -49.70342829151951,-24.60442745473524,0 -49.68138465129598,-24.60405106546596,0 -49.67913992962048,-24.60638100479324,0 -49.67245312135407,-24.60389687954642,0 -49.66551678582631,-24.6065604682459,0 -49.66518676890631,-24.61222786448783,0 -49.6524719761288,-24.62435620637603,0 -49.65072079875171,-24.63348408849715,0 -49.64535511631286,-24.63533131782551,0 -49.64150079249531,-24.64193827658821,0 -49.64478479271311,-24.64941665347357,0 -49.64730218685284,-24.66007977027286,0 -49.63354817660965,-24.66097727856179,0 -49.630035685041,-24.66465262900156,0 -49.62882592611865,-24.68075910946183,0 -49.62041739072273,-24.68264922014204,0 -49.6105553575157,-24.68059400917661,0 -49.60674171499178,-24.67580090238936,0 -49.59598054033985,-24.67681723093278,0 -49.58218404003816,-24.66742247471651,0 -49.57345406299822,-24.66797966068102,0 -49.56790222718448,-24.67698772265722,0 -49.56902892199356,-24.68238282552996,0 -49.5561372700155,-24.6885502648524,0 -49.55365537046195,-24.69935200961739,0 -49.54899041110183,-24.6987743464308,0 -49.54654782661079,-24.70583701612058,0 -49.53828637484432,-24.70634355347529,0 -49.53071827078936,-24.71461056463332,0 -49.52974280257718,-24.71553570110725,0 -49.53202114488734,-24.7201795151452,0 -49.55276105865331,-24.76330360138578,0 -49.56713305142678,-24.79706592368928,0 -49.56256222312447,-24.80096182995798,0 -49.56224629790214,-24.80765593206515,0 -49.55318472567748,-24.8110616876422,0 -49.5505537055405,-24.81699954123713,0 -49.53747997685671,-24.81819659133808,0 -49.53157466446381,-24.83754930466124,0 -49.53152539908597,-24.8462927012852,0 -49.526112616097,-24.84728343571784,0 -49.52555517508671,-24.85909741793469,0 -49.52838108354392,-24.86207938259049,0 -49.50855196184461,-24.8772560423217,0 -49.50932656887763,-24.88752586183278,0 -49.50000365333187,-24.89475056864416,0 -49.50430102981187,-24.8991025781074,0 -49.49875022074163,-24.90523589960295,0 -49.50952537966543,-24.90094885629395,0 -49.51107559635771,-24.91219609056608,0 -49.5153144210288,-24.91326754069556,0 -49.52885254309549,-24.90863402931607,0 -49.53942782668126,-24.91647134651971,0 -49.54446182510481,-24.92938662555567,0 -49.54806445332584,-24.93921204696663,0 -49.57286020308648,-24.93978429063054,0 -49.57184320284112,-24.94400596813441,0 -49.58004796222345,-24.94876942476233,0 -49.5748517288134,-24.95936628061639,0 -49.5920000881965,-24.97633261604731,0 -49.59598498987612,-24.97590429741242,0 -49.59916771418988,-24.98385603847308,0 -49.60363071819353,-24.9867312891647,0 -49.60797620600893,-24.98280650868517,0 -49.60613882272662,-24.98019347169219,0 -49.61083895884968,-24.97863071053435,0 -49.61676446122698,-24.97989430845587,0 -49.6322675603287,-24.99994327569386,0 -49.63879234424272,-25.00206256734106,0 -49.63868539471509,-25.00763604520958,0 -49.64924442839059,-25.00164717589618,0 -49.65268509356881,-25.00860374848056,0 -49.65479892783697,-25.00464755508377,0 -49.66374779540903,-25.00174633066854,0 -49.66821192188531,-24.99911704588629,0 -49.66868206936777,-25.00463717507299,0 -49.67610583612258,-25.00663777875959,0 -49.6769270923253,-25.00992802170222,0 -49.68121054180143,-25.01005222819227,0 -49.68907843123448,-25.01801590851741,0 -49.71213209489151,-25.0215017006182,0 -49.70491515511545,-25.02905316567805,0 -49.71545038270162,-25.03411088350797,0 -49.72254767229522,-25.03253613343317,0 -49.71676595362661,-25.03949591586244,0 -49.72455636718475,-25.04449124590672,0 -49.72812490458551,-25.04179572730319,0 -49.72617555010928,-25.03823263136226,0 -49.7327973717742,-25.04142600691225,0 -49.73655535664988,-25.03634320231962,0 -49.75086989948057,-25.03803292426233,0 -49.75314081655399,-25.04637646261611,0 -49.76805563615032,-25.04085369541187,0 -49.7720239946993,-25.04582455798484,0 -49.77175886140577,-25.05605138935459,0 -49.77869681547695,-25.052228320552,0 -49.77617004956698,-25.04891968198122,0 -49.77839342540558,-25.04763283429569,0 -49.7875655135666,-25.05819839882705,0 -49.79355110960073,-25.04936148395671,0 -49.79707890414097,-25.05034339679071,0 -49.80150916398253,-25.04800734532599,0 -49.80468356187478,-25.0500497063076,0 -49.80875563334896,-25.05927264457856,0 -49.80471786953801,-25.06035470296478,0 -49.80214873998524,-25.06770519052163,0 -49.81168291151269,-25.06837858596522,0 -49.81717082592745,-25.06084682404308,0 -49.82324279595758,-25.06044606348176,0 -49.82670666153217,-25.05090503390315,0 -49.83577313107674,-25.04857527997236,0 -49.83163134143868,-25.04253037035052,0 -49.83344436691593,-25.03787958767914,0 -49.8406883279324,-25.04424457276336,0 -49.85958998245206,-25.03851173052364,0 -49.86693098815017,-25.03951601196426,0 -49.87441889102988,-25.03371254183044,0 -49.88152922637816,-25.03704388651546,0 -49.87983299154989,-25.03980067931538,0 -49.88841107654692,-25.03936103542276,0 -49.8966602443499,-25.0458432833489,0 -49.90123107899481,-25.04371612099903,0 -49.90877135352503,-25.05282073257002,0 -49.91421422774845,-25.05584438975246,0 -49.91667517743242,-25.05339203738173,0 -49.92084834342079,-25.05775594222361,0 -49.91938357225896,-25.06458065649579,0 -49.92841949075876,-25.06464441571008,0 -49.93763482867563,-25.07233367380904,0 -49.97263201597816,-25.06460524639428,0 -49.97455959751809,-25.0481483514751,0 -49.97153021594985,-25.03586551824729,0 -49.97471576578046,-25.02241146405652,0 -49.97867107926757,-25.02091039873104,0 -49.97268209824143,-25.01821681463035,0 -49.9612193514851,-25.01418859682033,0 -49.95768930359151,-24.99845367537253,0 -49.95301798963716,-24.99493895920991,0 -49.95322135509969,-24.98057616433544,0 -49.93971345898614,-24.95812852776775,0 -49.93985609705177,-24.94612376119562,0 -49.95346986411495,-24.94031062107868,0 -49.95785780357538,-24.93485950674736,0 -49.97597368987151,-24.94339753284696,0 -49.98127612374502,-24.9382776385946,0 -49.98412760966436,-24.92271840080366,0 -49.99210236364344,-24.91485319193584,0 -49.99913259923841,-24.91458196456601,0 -50.00789388621556,-24.91944107711827,0 -50.02258024276205,-24.88664097470989,0 -50.0392283541593,-24.86823471252162,0 -50.04030403187911,-24.86691295840647,0 -50.04052658475332,-24.86663942858615,0 -50.0502244383663,-24.86127489544561,0 -50.06166735995118,-24.85953493770161,0 -50.06607604373311,-24.85538651070766,0 -50.07091819462908,-24.85717496960872,0 -50.07571531678192,-24.84851959048735,0 -50.07573983456412,-24.84335621131296,0 -50.06744236557331,-24.83811508566633,0 -50.07202767904639,-24.83081709132563,0 -50.0773060415995,-24.82508923843349,0 -50.07752885114393,-24.81927933410385,0 -50.0925804963295,-24.80791759338291,0 -50.10827864337525,-24.80708217622247,0 -50.13058408130405,-24.82132719315941,0 -50.13824768014074,-24.81796523579695,0 -50.14527386949689,-24.81385989152617,0 -50.14952636449944,-24.80814687059012,0 -50.14919355285318,-24.78320096106488,0 -50.15388700751718,-24.77687160494008,0 -50.16605452638896,-24.77039432224715,0 -50.17098110662953,-24.76122436390796,0 -50.18483043340278,-24.7563937306821,0 -50.19477623568812,-24.75587099305777,0 -50.20053506786649,-24.75899718489725,0 -50.21910998771878,-24.76165248317854,0 -50.23138873629408,-24.76837914733064,0 -50.24629960557377,-24.76519297204541,0 -50.23913785563061,-24.75311108755566,0 -50.22947297367791,-24.75253592376696,0 -50.21605640733407,-24.74003720292335,0 -50.19427170045013,-24.72862383939959,0 -50.18152647142382,-24.70983654764589,0 -50.17018644626883,-24.7059971322591,0 -50.16010551205424,-24.69330259158302,0 -50.16171612199825,-24.682430727908,0 -50.17982993235998,-24.66786537514917,0 -50.18997025209067,-24.65330045264636,0 -50.17374631461025,-24.64706458136067,0 -50.17907181707248,-24.63599458179229,0 -50.16796563955639,-24.63709975849211,0 -50.15619134378117,-24.62984951071181,0 -50.16752355656902,-24.61083615667379,0 -50.17903035663883,-24.60466656802041,0 -50.1702638178064,-24.59353278488013,0 -50.1590888121188,-24.59287446930135,0 -50.17406032466328,-24.57357869318571,0 -50.18463138125328,-24.56331981685895,0 -50.16861708078804,-24.55267260567275,0 -50.15316442111191,-24.55737382788259,0 -50.15338989355334,-24.54999214069826,0 -50.14166930888615,-24.54983284361737,0 -50.14109070504841,-24.54490066022413,0 -50.13478879426185,-24.54105530745717,0 ";
        var p = s.split(',');
        for (int i = 0; i < p.length - 1; i += 2) {
          points.add(new LatLng(double.parse(p[i + 1].replaceAll('0 ', '')),
              double.parse(p[i].replaceAll('0 ', ''))));
        }
        break;
      case 1:
        //Tibagi
        String s =
            "-50.31148770844176,-24.36220116398424,0 -50.30045078350433,-24.37464930136917,0 -50.28262711378911,-24.38457092876684,0 -50.2811909169649,-24.40326102657798,0 -50.27336459292435,-24.39683470845186,0 -50.25175345849038,-24.41721602686633,0 -50.2447439525221,-24.41976336908595,0 -50.24204643986291,-24.41692883477969,0 -50.23713689459369,-24.4238218045567,0 -50.21302190475367,-24.42832194197466,0 -50.2096873003744,-24.42474255023376,0 -50.18008014200966,-24.44981864234894,0 -50.15617571163947,-24.4585431295695,0 -50.14199767812445,-24.46466581753796,0 -50.11910788126165,-24.48412154713791,0 -50.10739930750754,-24.48790154949162,0 -50.1005218661577,-24.49638892190965,0 -50.10555689233405,-24.50178477806931,0 -50.10473604632344,-24.50573892264816,0 -50.08597345375069,-24.52325020630832,0 -50.09090692951558,-24.52591266969479,0 -50.10452624864772,-24.52014368988315,0 -50.10711463946367,-24.52327793073363,0 -50.10322262419498,-24.53153381611061,0 -50.11755146703553,-24.53891853821035,0 -50.13196928345123,-24.53335602817946,0 -50.13037109752106,-24.53714352307815,0 -50.13542267359474,-24.53854387679326,0 -50.13478879426185,-24.54105530745717,0 -50.14109070504841,-24.54490066022413,0 -50.14166930888615,-24.54983284361737,0 -50.15338989355334,-24.54999214069826,0 -50.15316442111191,-24.55737382788259,0 -50.16861708078804,-24.55267260567275,0 -50.18463138125328,-24.56331981685895,0 -50.17406032466328,-24.57357869318571,0 -50.1590888121188,-24.59287446930135,0 -50.1702638178064,-24.59353278488013,0 -50.17903035663883,-24.60466656802041,0 -50.16752355656902,-24.61083615667379,0 -50.15619134378117,-24.62984951071181,0 -50.16796563955639,-24.63709975849211,0 -50.17907181707248,-24.63599458179229,0 -50.17374631461025,-24.64706458136067,0 -50.18997025209067,-24.65330045264636,0 -50.17982993235998,-24.66786537514917,0 -50.16171612199825,-24.682430727908,0 -50.16010551205424,-24.69330259158302,0 -50.17018644626883,-24.7059971322591,0 -50.18152647142382,-24.70983654764589,0 -50.19427170045013,-24.72862383939959,0 -50.21605640733407,-24.74003720292335,0 -50.22947297367791,-24.75253592376696,0 -50.23913785563061,-24.75311108755566,0 -50.24629960557377,-24.76519297204541,0 -50.25569761212827,-24.77044113696565,0 -50.26316606957945,-24.76745224624054,0 -50.26849713365386,-24.77638288597888,0 -50.27628055829791,-24.78010401994898,0 -50.28413465262272,-24.78073970643074,0 -50.28841397870432,-24.7768519048356,0 -50.3032007915533,-24.78133179621259,0 -50.30672020236544,-24.78924843859308,0 -50.30643608288555,-24.80420074525987,0 -50.29546685133508,-24.81945528267898,0 -50.29903142505757,-24.8216719368397,0 -50.29730683963727,-24.83443020346783,0 -50.30624661827868,-24.83294894000715,0 -50.30641329069535,-24.84166193199159,0 -50.29861401590846,-24.84666480441932,0 -50.29686086442203,-24.85404826237662,0 -50.31421474650452,-24.85224726232638,0 -50.31613849872201,-24.83840361539395,0 -50.32783220116696,-24.84587633872259,0 -50.33913447239006,-24.84591884730922,0 -50.35689263748468,-24.83610043018318,0 -50.35944911856416,-24.83734188758701,0 -50.33897141557564,-24.87132984111935,0 -50.31614104690058,-24.86071693905885,0 -50.31727931025756,-24.86642560592969,0 -50.33952677787917,-24.88200167075216,0 -50.33377494753532,-24.8883969915521,0 -50.32921543680159,-24.88720321764783,0 -50.32322894564012,-24.89233553905558,0 -50.32434778250826,-24.90055001825633,0 -50.33856046792862,-24.89340705522586,0 -50.3475851680499,-24.90842795535952,0 -50.36184313917698,-24.91305026189271,0 -50.36148485635806,-24.92234844729835,0 -50.36498282778703,-24.92666112168863,0 -50.38068826079108,-24.92444434725927,0 -50.37861268767625,-24.93957122517363,0 -50.39945480636414,-24.93885569590849,0 -50.38607996013486,-24.94997260941965,0 -50.38736988105001,-24.95494904413685,0 -50.39383608613466,-24.95713228342492,0 -50.41414045150753,-24.96327215695104,0 -50.39170254945531,-24.9788071146728,0 -50.39201045822956,-24.98617421113891,0 -50.39634099150237,-24.99009090668783,0 -50.41366765827346,-24.99020780372209,0 -50.41994997904155,-25.0074135849762,0 -50.43024663843627,-25.00428783050475,0 -50.43354745215479,-24.99853078009223,0 -50.43956879247611,-24.99995510994474,0 -50.44760139110301,-24.9913083083481,0 -50.4524085441514,-24.99322158214,0 -50.4539657812897,-24.98813021449746,0 -50.45525760618324,-24.99082976158992,0 -50.45634279210681,-24.98778463680016,0 -50.46063471830364,-24.9892481015025,0 -50.47026175275893,-24.98415050987552,0 -50.46934006656527,-24.99455427175986,0 -50.47455374017363,-24.99748002642619,0 -50.47686548600598,-24.99161365867629,0 -50.4835526230759,-24.98817408087789,0 -50.49782909078783,-24.97424256557792,0 -50.50236792511711,-24.95322151352915,0 -50.51350027445189,-24.94131868751726,0 -50.52715559287475,-24.93785642728207,0 -50.52405206091994,-24.93308014199737,0 -50.46729406701093,-24.84883444240656,0 -50.4380103423359,-24.80415432099984,0 -50.44474026645739,-24.79807938342994,0 -50.45372776785809,-24.80323513207818,0 -50.46004626977433,-24.79966708416319,0 -50.46799302424836,-24.80069495194137,0 -50.47622831040506,-24.80754305027515,0 -50.48893176242597,-24.80930382758753,0 -50.48839105332549,-24.81472274924894,0 -50.49930740262564,-24.82165514241152,0 -50.50986030176485,-24.83699547003393,0 -50.52375255467508,-24.83245963257855,0 -50.54961129599166,-24.84991964410978,0 -50.55442507734848,-24.86130901648934,0 -50.55853029852327,-24.86521862884787,0 -50.5721965045878,-24.86099783571332,0 -50.57750389970473,-24.86910944571563,0 -50.59011169726548,-24.87790070876641,0 -50.61725545397512,-24.88483049519848,0 -50.62738722356672,-24.88022616723469,0 -50.63600630462996,-24.86061717170653,0 -50.65158829994191,-24.85026121992781,0 -50.65900821599888,-24.84900143600949,0 -50.65913707181045,-24.84892044991966,0 -50.66522279853388,-24.85153157889481,0 -50.67072693151778,-24.84704524720502,0 -50.6797580532118,-24.85576951315714,0 -50.6876413371031,-24.8564339745308,0 -50.69392211165264,-24.85305148783218,0 -50.71403320835662,-24.85494744658422,0 -50.73216919286743,-24.85056433834959,0 -50.7496910617399,-24.83138483149648,0 -50.7681728477228,-24.84450171727549,0 -50.77200339617065,-24.84214948172462,0 -50.77723320661698,-24.85193075157804,0 -50.7827506377636,-24.85449350051922,0 -50.80564799311507,-24.85265754697781,0 -50.82058666332495,-24.84587013988803,0 -50.82877447745307,-24.85333096538244,0 -50.83994430983326,-24.85981912419338,0 -50.84975570221876,-24.85637717992096,0 -50.84983309456678,-24.8511768157751,0 -50.86144404956384,-24.8460718746504,0 -50.86572538974697,-24.84339286642586,0 -50.86645227125372,-24.8346147438716,0 -50.8758630725266,-24.83188038308497,0 -50.8753495583777,-24.82321063547535,0 -50.87664000039398,-24.81981128999424,0 -50.86992173607161,-24.81552951274078,0 -50.86411707559446,-24.80008865890357,0 -50.86028049496925,-24.79016605030921,0 -50.83433246487457,-24.78167192452594,0 -50.82470009543535,-24.76801235535003,0 -50.82470051061799,-24.76294388494953,0 -50.81600620717932,-24.75454359351793,0 -50.81078141662736,-24.74697242972745,0 -50.78620550581111,-24.7531658612358,0 -50.77613740137207,-24.74478458409236,0 -50.77252787896007,-24.73568771904931,0 -50.77352302893446,-24.72322316517119,0 -50.77009043163715,-24.72333694471839,0 -50.76869931088923,-24.71897910111551,0 -50.77136980531023,-24.71223127202008,0 -50.76905607014793,-24.70861384949044,0 -50.77659749390929,-24.70532091645821,0 -50.77350977942184,-24.69456962329809,0 -50.77954504385128,-24.69230649079278,0 -50.78289939668341,-24.68289360911346,0 -50.77818969568467,-24.6823661707429,0 -50.77990587074214,-24.67796676160048,0 -50.77566524062855,-24.67592518935217,0 -50.7720089914385,-24.68108733961262,0 -50.77118818704875,-24.66296524323008,0 -50.76717386224426,-24.6614450930348,0 -50.76700768667479,-24.66129812900629,0 -50.76989902154743,-24.65197838028564,0 -50.76528381079681,-24.65174125174041,0 -50.76906674654199,-24.64857589768362,0 -50.76332797432525,-24.6458210067722,0 -50.75864309943564,-24.64775381752776,0 -50.7590489095041,-24.65139786016807,0 -50.75620714637612,-24.6500226518026,0 -50.76209272319968,-24.64265062594557,0 -50.76154264789684,-24.63257066290265,0 -50.75905533439512,-24.63512164674143,0 -50.7563451665658,-24.63199342682616,0 -50.75809332184001,-24.63866859957221,0 -50.75293951053726,-24.63658520326778,0 -50.74811793899282,-24.64532537893234,0 -50.74379139407766,-24.63637317345474,0 -50.74863376487583,-24.63411143256789,0 -50.74688095225235,-24.63141136330048,0 -50.74309814988984,-24.63358144771015,0 -50.74119312114945,-24.62936656687884,0 -50.74976470401595,-24.62370345346518,0 -50.73651699897297,-24.62694489366022,0 -50.73680493718518,-24.62099638063923,0 -50.74264286625165,-24.6175415926955,0 -50.73864271291021,-24.61569376521194,0 -50.74361429511312,-24.61097112061248,0 -50.73478737708567,-24.6128389358384,0 -50.74331058088194,-24.60580518328492,0 -50.74656489464289,-24.60741852155368,0 -50.74490965314737,-24.60054418008217,0 -50.74240901365057,-24.60396670279094,0 -50.74112526008498,-24.60079336258109,0 -50.7472352934004,-24.59716111494904,0 -50.75198386593584,-24.58817932200163,0 -50.74438579729316,-24.58655716845174,0 -50.74310479487206,-24.58125829082846,0 -50.74623299253504,-24.58130959176767,0 -50.74334254165739,-24.57894030444384,0 -50.73353413312251,-24.58412559843018,0 -50.73378385823636,-24.57792914337919,0 -50.73033799111812,-24.57938937814374,0 -50.72621409776946,-24.5744147313491,0 -50.72416455739899,-24.56540160648973,0 -50.71988834608903,-24.55981660634702,0 -50.71558638326828,-24.5657967693948,0 -50.71168538465435,-24.55387095009095,0 -50.71966669857427,-24.5550195129058,0 -50.72092135667995,-24.54816227201112,0 -50.710456280488,-24.54876062924978,0 -50.70375336977273,-24.54212315583876,0 -50.70635366407085,-24.53479585226218,0 -50.70033553657827,-24.54035038450777,0 -50.69905443618719,-24.53204196033377,0 -50.69380819510094,-24.52897107245711,0 -50.68890854228012,-24.52695822349262,0 -50.68867217616045,-24.51768519194537,0 -50.68219870885351,-24.51398195977797,0 -50.69078600262967,-24.50926894966172,0 -50.68752902407831,-24.50008574998562,0 -50.68070206294324,-24.50295703391783,0 -50.68194485401939,-24.49900376353855,0 -50.68717214303079,-24.49822742347287,0 -50.69480519779287,-24.49014112959343,0 -50.69166489147903,-24.48317451335797,0 -50.68364204992891,-24.48811204015339,0 -50.68050153595255,-24.48256828804516,0 -50.67199495419245,-24.49004573007624,0 -50.66634792902174,-24.48100439737954,0 -50.65344940519596,-24.48090894232971,0 -50.66397464736851,-24.47730612053194,0 -50.66308470419302,-24.47023536909261,0 -50.6688936513868,-24.47033541450011,0 -50.66233446073674,-24.46834218925733,0 -50.66527945238095,-24.46370966915879,0 -50.65822249814885,-24.45861218503195,0 -50.6651961272756,-24.45526612222459,0 -50.65503246428986,-24.45306424809714,0 -50.65817119978058,-24.44370172141964,0 -50.65364223195697,-24.43963382782736,0 -50.65591853487662,-24.42739267942565,0 -50.64716595154697,-24.42793960180412,0 -50.6467219034751,-24.4226903897958,0 -50.64177292260691,-24.41925139899372,0 -50.63830622302556,-24.42166435782118,0 -50.63364194631922,-24.41865617776646,0 -50.62472041981033,-24.41997271913129,0 -50.62535926269576,-24.41231284192063,0 -50.6167190980204,-24.4159978451003,0 -50.61195072125528,-24.40661214236934,0 -50.61566767998169,-24.39774058681612,0 -50.60487460468248,-24.3946398363991,0 -50.60111743849991,-24.39666850810215,0 -50.60295374750162,-24.40410320307135,0 -50.59260372556612,-24.40972154357026,0 -50.58270540161634,-24.41947568102195,0 -50.57594884553325,-24.41653137546595,0 -50.55858350965329,-24.41899566632913,0 -50.55645237858119,-24.41459189191868,0 -50.56205128355202,-24.40892262921796,0 -50.54948300805167,-24.40993016729462,0 -50.53157534655463,-24.43586424783716,0 -50.52076380942015,-24.43956759544755,0 -50.51856174151887,-24.43505535082554,0 -50.51463423309973,-24.43482256775882,0 -50.50939941788691,-24.44683982852823,0 -50.49615085217619,-24.45348409993424,0 -50.48401165049439,-24.46819045672879,0 -50.4763386315249,-24.47086129594882,0 -50.47615728448774,-24.46398358515484,0 -50.47056591640947,-24.46850594285649,0 -50.46531118746706,-24.46372256575746,0 -50.47133912014195,-24.46084441039622,0 -50.46835448343683,-24.45098263180327,0 -50.46544362358523,-24.45947698421537,0 -50.46364749528116,-24.45522153007975,0 -50.45665143667632,-24.45522295950719,0 -50.46227414134911,-24.4523275454372,0 -50.45670531483741,-24.45178346263527,0 -50.45670065374451,-24.44913065123941,0 -50.46236559683505,-24.4465490756508,0 -50.44659181485045,-24.44686594027662,0 -50.44447948987366,-24.43668261455686,0 -50.43510212978897,-24.43163657884768,0 -50.42940409074387,-24.41982061790515,0 -50.41154940977788,-24.4191942750554,0 -50.41026064354771,-24.41078663141353,0 -50.39688492767208,-24.41012491624841,0 -50.39118023179627,-24.40073674001059,0 -50.38015544002267,-24.40585576677212,0 -50.37193399086161,-24.40238011050444,0 -50.35772960303705,-24.38004585277099,0 -50.35903529328788,-24.37608486524499,0 -50.32952711875108,-24.36652594782644,0 -50.32572542941222,-24.36880696664069,0 -50.31148770844176,-24.36220116398424,0";
        var p = s.split(',');
        for (int i = 0; i < p.length - 1; i += 2) {
          points.add(new LatLng(double.parse(p[i + 1].replaceAll('0 ', '')),
              double.parse(p[i].replaceAll('0 ', ''))));
        }
        break;
      case 2:
        String s =
            "-50.3193088950072,-24.89137806852435,0 -50.31462995080656,-24.90679271373167,0 -50.3036629837953,-24.92233914963815,0 -50.28170864813883,-24.93139522630392,0 -50.26686350437612,-24.93378874634541,0 -50.25303169982368,-24.95277029303663,0 -50.24670476039219,-24.95574213817113,0 -50.21013257108653,-24.95986844573458,0 -50.20762863379007,-24.95400928016502,0 -50.20194886253247,-24.95854428431532,0 -50.20254007110707,-24.95403579607676,0 -50.19940861264583,-24.9571021531597,0 -50.19651356641819,-24.95689044449314,0 -50.19713995987074,-24.95320862842694,0 -50.19324771774041,-24.95585249934831,0 -50.19197245883398,-24.96361303418696,0 -50.1818443092217,-24.96109146787941,0 -50.16984781346402,-24.96967390864351,0 -50.17081755163753,-24.97389952366471,0 -50.15761680566575,-24.9873274859631,0 -50.16276078187035,-24.99601911531528,0 -50.14964015913731,-25.00216100334475,0 -50.15135158731912,-25.00641848260822,0 -50.15781961022236,-25.0070064155237,0 -50.15151317654709,-25.01041867238586,0 -50.13919488551469,-25.00906596779337,0 -50.13350625272187,-25.01121341186128,0 -50.12492854561426,-25.01073720577944,0 -50.11260610237601,-25.00370521493041,0 -50.07394947706872,-24.99690386661776,0 -50.06587064331121,-24.9905434843995,0 -50.03651010503512,-24.99286536208663,0 -50.02919393908955,-24.99221724796631,0 -50.01872317561278,-25.01019261629094,0 -50.00376260128864,-25.00563423884186,0 -49.99842773194054,-25.00945144176965,0 -49.99146511447365,-25.01872353377158,0 -49.99074855314391,-25.02195167222734,0 -49.98378948291946,-25.02428961838731,0 -49.97867107926757,-25.02091039873104,0 -49.97471576578046,-25.02241146405652,0 -49.97153021594985,-25.03586551824729,0 -49.97455959751809,-25.0481483514751,0 -49.97263201597816,-25.06460524639428,0 -49.93763482867563,-25.07233367380904,0 -49.92841949075876,-25.06464441571008,0 -49.91938357225896,-25.06458065649579,0 -49.92084834342079,-25.05775594222361,0 -49.91667517743242,-25.05339203738173,0 -49.91421422774845,-25.05584438975246,0 -49.90877135352503,-25.05282073257002,0 -49.90123107899481,-25.04371612099903,0 -49.8966602443499,-25.0458432833489,0 -49.88841107654692,-25.03936103542276,0 -49.87983299154989,-25.03980067931538,0 -49.88152922637816,-25.03704388651546,0 -49.87441889102988,-25.03371254183044,0 -49.86693098815017,-25.03951601196426,0 -49.85958998245206,-25.03851173052364,0 -49.8406883279324,-25.04424457276336,0 -49.83344436691593,-25.03787958767914,0 -49.83163134143868,-25.04253037035052,0 -49.83577313107674,-25.04857527997236,0 -49.82670666153217,-25.05090503390315,0 -49.82324279595758,-25.06044606348176,0 -49.81717082592745,-25.06084682404308,0 -49.81168291151269,-25.06837858596522,0 -49.80214873998524,-25.06770519052163,0 -49.80471786953801,-25.06035470296478,0 -49.80875563334896,-25.05927264457856,0 -49.80468356187478,-25.0500497063076,0 -49.80150916398253,-25.04800734532599,0 -49.79707890414097,-25.05034339679071,0 -49.79355110960073,-25.04936148395671,0 -49.7875655135666,-25.05819839882705,0 -49.77839342540558,-25.04763283429569,0 -49.77617004956698,-25.04891968198122,0 -49.77869681547695,-25.052228320552,0 -49.77175886140577,-25.05605138935459,0 -49.7720239946993,-25.04582455798484,0 -49.76805563615032,-25.04085369541187,0 -49.75314081655399,-25.04637646261611,0 -49.75086989948057,-25.03803292426233,0 -49.73655535664988,-25.03634320231962,0 -49.7327973717742,-25.04142600691225,0 -49.72617555010928,-25.03823263136226,0 -49.72812490458551,-25.04179572730319,0 -49.72455636718475,-25.04449124590672,0 -49.71676595362661,-25.03949591586244,0 -49.72254767229522,-25.03253613343317,0 -49.71545038270162,-25.03411088350797,0 -49.70491515511545,-25.02905316567805,0 -49.70314314813491,-25.03225051400486,0 -49.71101471735273,-25.03400661509281,0 -49.7117107658441,-25.03844388239802,0 -49.70158995244491,-25.04453901616283,0 -49.70207011138577,-25.04861863367363,0 -49.71119106516548,-25.04536471816484,0 -49.71639845554037,-25.0511096460936,0 -49.7126215758773,-25.05424757609126,0 -49.71306789324098,-25.06036091882401,0 -49.71871819681262,-25.0575021873493,0 -49.7222624078553,-25.06396146652125,0 -49.73297992356898,-25.05900670500557,0 -49.73942334882308,-25.06266158168966,0 -49.73693622609541,-25.06518557142879,0 -49.74281728242764,-25.07913492446716,0 -49.74195686825349,-25.08255799845123,0 -49.7382571301151,-25.08117240801454,0 -49.73530840063787,-25.08883840766815,0 -49.73893806813818,-25.09199188889342,0 -49.73586858493555,-25.10004099082146,0 -49.73954459122503,-25.10221089262381,0 -49.72953080886162,-25.10875482313395,0 -49.73154548505376,-25.11146380123121,0 -49.72809204517663,-25.11061931947037,0 -49.73115546475783,-25.11489035370206,0 -49.72798210844309,-25.12135473082067,0 -49.73276584058301,-25.12411990636907,0 -49.72481637992281,-25.13444598978327,0 -49.71461219827296,-25.13863839932855,0 -49.70765196295528,-25.13736140468768,0 -49.70333594200785,-25.14941483452295,0 -49.68021988360496,-25.16771323088376,0 -49.68136211591095,-25.17778266896348,0 -49.68789406018336,-25.18707006003436,0 -49.69370841914138,-25.19533620937458,0 -49.70909393833004,-25.20579270800448,0 -49.71216514724274,-25.21737060224404,0 -49.73191556554117,-25.22353966187299,0 -49.73679985244455,-25.21977852938979,0 -49.74583288799659,-25.22114575722421,0 -49.75416734515136,-25.21790929180944,0 -49.77232793259726,-25.19577049108827,0 -49.78087993443804,-25.19403618760007,0 -49.79279942402161,-25.19946117154105,0 -49.79707251960793,-25.21075772407781,0 -49.79918380404838,-25.21535766422609,0 -49.80984581968099,-25.2165941976765,0 -49.81728815056325,-25.22629844118193,0 -49.83202805272162,-25.22526770853876,0 -49.84912709419,-25.23386153894185,0 -49.85674313393729,-25.23388655867476,0 -49.84308131410441,-25.254048007432,0 -49.81963765102931,-25.27000867924735,0 -49.83753866415212,-25.27867930191053,0 -49.8462913326267,-25.290776156883,0 -49.86326142456959,-25.28350631106969,0 -49.88137304733133,-25.29813055238105,0 -49.88653974490405,-25.29581776242457,0 -49.89172286250814,-25.29916311409465,0 -49.89205755870169,-25.29934275197555,0 -49.91413970875434,-25.30939198495597,0 -49.92783608339614,-25.31175660214166,0 -49.92750276878598,-25.31758570010635,0 -49.93581268811765,-25.31891328608425,0 -49.94300298015623,-25.32866527431734,0 -49.95093564348454,-25.3290543265278,0 -49.95436309162881,-25.32301878819147,0 -49.9668001722466,-25.32351139907384,0 -49.97150028092936,-25.31406093009893,0 -49.97811548977096,-25.31802664393776,0 -49.97611265218325,-25.32204136707277,0 -49.98325363869571,-25.32138861703762,0 -49.99479658289549,-25.30663795018888,0 -49.99826087051802,-25.31382777960674,0 -50.00649277783921,-25.30310789211201,0 -50.01453613448238,-25.29943237197289,0 -50.02224730826855,-25.30711933170168,0 -50.03732465541089,-25.30309552196851,0 -50.03627320000041,-25.2937421885755,0 -50.04612521718398,-25.28356962684013,0 -50.04642600027542,-25.27543501761053,0 -50.05730219854096,-25.27008760936739,0 -50.05612273026199,-25.26178633712122,0 -50.06720174377007,-25.25834800317433,0 -50.07305855279811,-25.2513315549983,0 -50.07525133356038,-25.25561621002084,0 -50.07905764602555,-25.25287157544291,0 -50.07630820106305,-25.26239811517683,0 -50.09184042256395,-25.28005978291735,0 -50.08259538344652,-25.29076474359443,0 -50.08802887406363,-25.30483384413236,0 -50.08114260803433,-25.306730717852,0 -50.08011037345372,-25.3100915207303,0 -50.0905866007777,-25.31576118943434,0 -50.09166983442121,-25.31714461642182,0 -50.10526637347071,-25.32265075509781,0 -50.11729896648171,-25.33596653719624,0 -50.12876403609346,-25.33931896952742,0 -50.14036534468837,-25.33802654091735,0 -50.14912970968317,-25.34465278653122,0 -50.15909660578927,-25.36082606324687,0 -50.16351787961659,-25.37895310979133,0 -50.16906027660622,-25.38438136231246,0 -50.19281414017844,-25.38575243483698,0 -50.20076224786043,-25.39374055918519,0 -50.21456992464963,-25.39397794827149,0 -50.23255221874651,-25.40211213259278,0 -50.24273416338026,-25.40394170148218,0 -50.24801306222743,-25.39850255695713,0 -50.25729221240512,-25.39765869522875,0 -50.25604039231435,-25.38951997712891,0 -50.25125877863398,-25.38864655633242,0 -50.2511007215934,-25.38308409913128,0 -50.24197836066239,-25.37537410779129,0 -50.24356458820196,-25.36802977534928,0 -50.23912367163911,-25.36302342125409,0 -50.25003182214578,-25.3548220884769,0 -50.24807147532137,-25.34830781330288,0 -50.24409535822151,-25.34711674472885,0 -50.25025764634091,-25.34216491852531,0 -50.25009757774546,-25.33811055447498,0 -50.25480744359852,-25.33689601449368,0 -50.24992532808689,-25.3312946829789,0 -50.25009843043557,-25.32230062036952,0 -50.24233426465437,-25.3227927824015,0 -50.24634554514376,-25.3088797407238,0 -50.2514521097565,-25.30929523520737,0 -50.2537731013421,-25.30460878876652,0 -50.26733216169043,-25.3006358432179,0 -50.2761203413923,-25.2885361538532,0 -50.27625906355838,-25.28724781709576,0 -50.27263709660419,-25.28223076319571,0 -50.27008932384187,-25.27402516070944,0 -50.2729888538487,-25.26572889170848,0 -50.26781685311553,-25.25754815292512,0 -50.27127923915705,-25.2476524234897,0 -50.26774987103181,-25.24263228161015,0 -50.26972398710271,-25.24041753620295,0 -50.2630007774616,-25.2336138478212,0 -50.27327938000207,-25.22539725515154,0 -50.28047454642356,-25.21178535537139,0 -50.26180448320216,-25.1987304469233,0 -50.26708814941092,-25.190821511721,0 -50.27428090996149,-25.18765802071143,0 -50.27285898748503,-25.15974714786526,0 -50.27686496606496,-25.15360039797552,0 -50.2731113782512,-25.14949266360341,0 -50.27453626126524,-25.1459305808737,0 -50.2804401371631,-25.13253366160503,0 -50.28372214410308,-25.13687549252975,0 -50.29302277351355,-25.13405201345188,0 -50.29255665479432,-25.13867413075722,0 -50.29768917469856,-25.13790167495284,0 -50.30000158961352,-25.14115973258798,0 -50.31141516202536,-25.13273252174344,0 -50.31094515585898,-25.12985580042896,0 -50.31846996370992,-25.13433482383393,0 -50.32586805549283,-25.13382219969611,0 -50.3331050013648,-25.12495879015053,0 -50.35011583502828,-25.11566117094312,0 -50.3514444737074,-25.11067129256158,0 -50.35608403872863,-25.11208345534377,0 -50.36922628324963,-25.10469524170726,0 -50.37130088580771,-25.09889479807802,0 -50.36686021400179,-25.10015752397074,0 -50.37058527712867,-25.09696690174398,0 -50.37661897606385,-25.08576526448742,0 -50.3940026458157,-25.07966701614084,0 -50.39297367459841,-25.07610785592659,0 -50.39283304130359,-25.07593314296213,0 -50.38463691109994,-25.06162797522158,0 -50.3850034043642,-25.05924320280406,0 -50.39097752524691,-25.06445428246206,0 -50.39903264018459,-25.06392831854623,0 -50.4102217909761,-25.07426965293329,0 -50.41186359384192,-25.06662773261143,0 -50.4019694188437,-25.05609160086559,0 -50.40722541005073,-25.04852810368857,0 -50.41667028599186,-25.0452396975595,0 -50.40636129727361,-25.03914060953664,0 -50.40985974137563,-25.02940040161077,0 -50.42414308338211,-25.0381237473778,0 -50.42533319056837,-25.04558244894835,0 -50.43308270423701,-25.0419014694413,0 -50.43717520641203,-25.03005679890993,0 -50.43894880151833,-25.01903015168436,0 -50.45246974667137,-25.02927168491986,0 -50.45847394131137,-25.01099358027113,0 -50.43239161152405,-25.01581671052337,0 -50.43024663843627,-25.00428783050475,0 -50.41994997904155,-25.0074135849762,0 -50.41366765827346,-24.99020780372209,0 -50.39634099150237,-24.99009090668783,0 -50.39201045822956,-24.98617421113891,0 -50.39170254945531,-24.9788071146728,0 -50.41414045150753,-24.96327215695104,0 -50.39383608613466,-24.95713228342492,0 -50.38736988105001,-24.95494904413685,0 -50.38607996013486,-24.94997260941965,0 -50.39945480636414,-24.93885569590849,0 -50.37861268767625,-24.93957122517363,0 -50.38068826079108,-24.92444434725927,0 -50.36498282778703,-24.92666112168863,0 -50.36148485635806,-24.92234844729835,0 -50.36184313917698,-24.91305026189271,0 -50.3475851680499,-24.90842795535952,0 -50.33856046792862,-24.89340705522586,0 -50.32434778250826,-24.90055001825633,0 -50.32322894564012,-24.89233553905558,0 -50.3193088950072,-24.89137806852435,0 ";
        var p = s.split(',');
        for (int i = 0; i < p.length - 1; i += 2) {
          points.add(new LatLng(double.parse(p[i + 1].replaceAll('0 ', '')),
              double.parse(p[i].replaceAll('0 ', ''))));
        }
        //PG
        break;
    }
    return points;
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
