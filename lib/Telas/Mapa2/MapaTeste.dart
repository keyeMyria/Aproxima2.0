import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:aproxima/Telas/Mapa/MapaController.dart';
import 'package:aproxima/Telas/Mapa2/ControllerSnackBar.dart';
import 'package:aproxima/Telas/UserProfile/friend_details_page.dart';
import 'package:aproxima/Widgets/FeedUtils/Bolinhas.dart';
import 'package:aproxima/Widgets/FeedUtils/FotoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage();

  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapaController mc;
  SnackBar showingSnackbar;
  GoogleMapController mapController;
  LatLng _center = LatLng(Helpers.user.cidade.lat, Helpers.user.cidade.lng);
  ControllerSnackBar csb;
  bool isShown = false;

  void _onMapCreated(
      GoogleMapController controller, List<Protocolo> protocolos) {
    mapController = controller;
    if (protocolos != null) {
      List<Protocolo> ps = new List();
      List<Marker> markers = new List();
      for (Protocolo p in protocolos) {
        print('ENTROU FOREACH');
        DateTime now = DateTime.now();
        bool show = false;
        if (p.updated_at != null) {
          if (p.updated_at
              .isAfter(DateTime.now().subtract(Duration(days: 30)))) {
            show = true;
          }
        } else {
          if (p.created_at
              .isAfter(DateTime.now().subtract(Duration(days: 30)))) {
            show = true;
          }
        }
        if (show) {
          BitmapDescriptor c;
          switch (p.status.descricao) {
            case 'Em Andamento':
              c = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue);
              break;

            case 'Enviado':
              c = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow);
              break;

            case 'Encaminhado':
              c = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange);
              break;

            case 'Concluído':
              c = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen);
              break;

            case 'Excluído':
              c = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed);
              break;
          }

          mapController
              .addMarker(new MarkerOptions(
                  icon: c,
                  draggable: false,
                  position: LatLng(p.lat, p.lng),
                  visible: true,
                  consumeTapEvents: false,
                  alpha: 1))
              .then((mm) {
            p.m = mm;
            ps.add(p);
          });
        }
      }
      mc.inMapa.add(ps);
      mapController.onMarkerTapped.add(_onMarkerTapped);
    } else {
      mc.Fetch();
    }
  }

  dotList(int length, int selecionado) {
    List<Widget> l = new List();
    for (int i = 0; i < length; i++) {
      l.add(Container(
        height: 15.0,
        width: 15.0,
        decoration: BoxDecoration(
          color: i == selecionado ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
              color: Colors.green, width: 1.0, style: BorderStyle.solid),
        ),
      ));
    }
    return l;
  }

  void _onMarkerTapped(Marker marker) {
    mc.outMapa.first.then((protocolos) {
      for (Protocolo p in protocolos) {
        print('FDP ${p.m.id}  ${marker.id}');
        if (p.m.id == marker.id) {
          print('ACHOU DE VERDADE FDP ${p.m.id}  ${marker.id}');
          _showDialog(p);
        }
      }
    }).catchError((err) {
      print('Erro: ${err.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    mc = new MapaController();
    return Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: StreamBuilder(
            stream: mc.outMapa,
            builder: (context, protocolos) {
              if (protocolos.hasData) {
                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: (c) {
                        _onMapCreated(c, protocolos.data);
                      },
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                      compassEnabled: true,
                      myLocationEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      trackCameraPosition: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed: () => print('button pressed'),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.map, size: 36.0),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  child: SpinKitThreeBounce(
                    color: Colors.green,
                    size: 50,
                  ),
                );
              }
            }));
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
                  color: Colors.green[500],
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline),
                  color: Colors.green[500],
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
                backgroundImage: NetworkImage(
                    'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'),
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
          getStatus(post.status.descricao, context),
        ],
      ),
    );
  }

  Widget getStatus(String status, BuildContext context) {
    Color c;
    print('Status: ${status}');
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

  getTagss(List<Tagss> tags) {
    List<Widget> l = new List();
    for (int i = 0; i < tags.length; i++) {
      l.add(Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            '#' + tags[i].tag.tag_nome,
            style: TextStyle(
                fontStyle: FontStyle.italic, color: Colors.green[900]),
          ),
        ),
      ));
    }
    return l;
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
                                color: Colors.green[500],
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.chat_bubble_outline),
                                color: Colors.green[500],
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
                                itemWidth: MediaQuery.of(context).size.width,
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
                                                                fotos: p.fotos,
                                                                index: i),
                                                      ));
                                                },
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .4,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CachedNetworkImage(
                                                    imageUrl: p.fotos[i].link,
                                                    placeholder:
                                                        SpinKitThreeBounce(
                                                      color: Colors.green,
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
                                width: MediaQuery.of(context).size.width * .9,
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
                                                          selecionado.data)));
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
}
