import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Apoio.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:aproxima/Telas/UserProfile/friend_details_page.dart';
import 'package:aproxima/Widgets/FeedUtils/ApoioProtocoloController.dart';
import 'package:aproxima/Widgets/FeedUtils/Bolinhas.dart';
import 'package:aproxima/Widgets/FeedUtils/FotoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:latlong/latlong.dart';
import 'package:share/share.dart';

class ActivityFeedItem extends StatelessWidget {
  Protocolo protocolo;
  String type;
  bool hideComment;
  ActivityFeedItem({this.protocolo, this.type, this.hideComment = false});

  Widget profileColumn(BuildContext context, Protocolo post) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.titulo,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .apply(fontWeightDelta: 700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  post.endereco,
                  style: Theme.of(context).textTheme.caption.apply(
                      //fontFamily: UIData.ralewayFont,
                      color: Colors.pink),
                )
              ],
            ),
          ))
        ],
      );

  //column last
  Widget actionColumn(Protocolo post, BuildContext context) {
    ApoioProtocoloController apc = new ApoioProtocoloController(post);
    bool userLiked = false;

    return Padding(
        padding: EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: () {
              if (!hideComment) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ComentarioPage(post)));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder(
                      stream: apc.outApoio,
                      builder: (context, AsyncSnapshot<List<Apoio>> snap) {
                        Apoio apoio = null;
                        bool userLiked = false;
                        if (snap.hasData) {
                          for (Apoio a in snap.data) {
                            if (a.id == Helpers.user.id) {
                              userLiked = true;
                              apoio = a;
                            }
                          }
                        }
                        return IconButton(
                          icon: Container(
                            height: 60,
                            width: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  userLiked ? Icons.thumb_up : Icons.thumb_up,
                                  size: 25,
                                  color: userLiked
                                      ? Colors.blue[500]
                                      : Colors.grey,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                ),
                                Text(
                                  snap.hasData
                                      ? snap.data.length.toString()
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: userLiked
                                          ? Colors.blue[500]
                                          : Colors.grey,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          iconSize: 40,
                          color: Colors.blue[500],
                          onPressed: () {
                            !userLiked
                                ? apc.ApoiarProtocolo(post)
                                : apc.DesapoiarProtocolo(post, apoio);
                          },
                        );
                      },
                    ),
                    hideComment
                        ? new Container()
                        : IconButton(
                            icon: Icon(Icons.chat_bubble_outline),
                            color: Colors.blue[500],
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ComentarioPage(post)));
                            },
                          ),
                    IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.blue[500],
                      onPressed: () {
                        Helpers.nh.getDL(post, true).then((link) {
                          Share.share('${link}');
                        }).catchError((err) {
                          print('error:${err.toString()}');
                        });
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
                            fontWeight: FontWeight.normal, fontSize: 17))),
              ],
            )));
  }

  //post cards
  Widget postCard(BuildContext context, Protocolo post) {
    ApoioProtocoloController apc = new ApoioProtocoloController(post);
    bool userLiked = false;
    BolinhasController bc =
        new BolinhasController(post.fotos != null ? post.fotos.length : 0, 0);
    var map = new FlutterMap(
      options: new MapOptions(
        interactive: true,
        center: LatLng(post.lat, post.lng),
        zoom: 14,
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
        new MarkerLayerOptions(markers: [
          Marker(
              point: LatLng(post.lat, post.lng),
              builder: (context) {
                return Icon(
                  Icons.place,
                  color: Colors.blue,
                  size: 35,
                );
              })
        ]),
      ],
    );
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(), //profileColumn(context, post),
          ),
          TopArea(post, context),
          SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: <Widget>[
                Swiper(
                    onIndexChanged: (newindex) {
                      bc.inSelecionado.add(newindex);
                    },
                    itemCount: post.fotos != null ? post.fotos.length + 1 : 1,
                    itemWidth: MediaQuery.of(context).size.width,
                    layout: SwiperLayout.DEFAULT,
                    itemHeight: MediaQuery.of(context).size.height * .4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext c, int i) {
                      if (post.fotos != null) {
                        if (i != post.fotos.length) {
                          return post.fotos[i].link != null
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    hideComment
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FotoPage(
                                                            fotos: post.fotos,
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
                                                imageUrl: post.fotos[i].link,
                                                placeholder: SpinKitThreeBounce(
                                                  color: Colors.blue,
                                                  size: 50,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ))
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FotoPage(
                                                            fotos: post.fotos,
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
                                                imageUrl: post.fotos[i].link,
                                                placeholder: SpinKitThreeBounce(
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
                        } else {
                          return map;
                        }
                      } else {
                        return map;
                      }
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
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: dotList(total.data + 1,
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
          actionColumn(post, context),
        ],
      ),
    );
  }

  Widget getStatus(String status, BuildContext context) {
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
              // print('Click Snackbar');
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

  Widget bodyList(List<Protocolo> posts, BuildContext c) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: postCard(c, posts[index]),
          );
        }, childCount: posts.length),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      //drawer: CommonDrawer(),
      child: postCard(context, protocolo),
    );
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
    if (tags != null) {
      print('AQUI TAGS ${tags}');

      for (int i = 0; i < tags.length; i++) {
        l.add(Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              '#' + tags[i].tag.tag_nome,
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.blue[900]),
            ),
          ),
        ));
      }
      return l;
    } else {
      l.add(Container());
      return l;
    }
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
            child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: 50,
                height: 50,
                placeholder: Image.asset(
                  'assets/logo_sem_texto_teste.png',
                  width: 50,
                  height: 50,
                ),
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/aproximamais-b84ee.appspot.com/o/usuarios%2F${post.usuario.id}.jpeg?alt=media&token=5cae4fd3-d3d4-44e4-893a-2349f6fda687'),
          ),
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
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 5.0),
                child: Text(
                  post.cidade.cidade,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
              ),
            ],
          ),
          getStatus(post.status.descricao, context),
        ],
      ),
    );
  }
}
