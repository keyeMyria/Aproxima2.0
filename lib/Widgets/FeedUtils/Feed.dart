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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ActivityFeedItem extends StatelessWidget {
  Protocolo protocolo;
  String type;
  bool hideComment;
  ActivityFeedItem({this.protocolo, this.type, this.hideComment = false});

  //TODO Arrumar esse Constructor

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
                      icon: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Icon(
                            userLiked ? Icons.favorite : Icons.favorite_border,
                            size: 35,
                          ),
                          Center(
                              child: Text(
                            snap.hasData ? snap.data.length.toString() : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: userLiked
                                    ? Colors.white
                                    : Colors.green[500],
                                fontSize: 14),
                          ))
                        ],
                      ),
                      color: Colors.green[500],
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
        ));
  }

  //post cards
  Widget postCard(BuildContext context, Protocolo post) {
    ApoioProtocoloController apc = new ApoioProtocoloController(post);
    bool userLiked = false;
    if (post.fotos == null) {
      return Card(
        elevation: 2.0,
        child: Column(
          children: <Widget>[
            TopArea(post, context),
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
                          icon: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(
                                userLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 35,
                              ),
                              Center(
                                  child: Text(
                                snap.hasData ? snap.data.length.toString() : '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: userLiked
                                        ? Colors.white
                                        : Colors.green[500],
                                    fontSize: 14),
                              ))
                            ],
                          ),
                          color: Colors.green[500],
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
                            color: Colors.green[500],
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ComentarioPage(post)));
                            },
                          ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Text(
                    post.titulo,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: getTagss(post.tags),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      BolinhasController bc = new BolinhasController(post.fotos.length, 0);
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
                      itemCount: post.fotos.length,
                      itemWidth: MediaQuery.of(context).size.width,
                      layout: SwiperLayout.DEFAULT,
                      itemHeight: MediaQuery.of(context).size.height * .4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext c, int i) {
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
                                                color: Colors.green,
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
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: dotList(
                                                total.data, selecionado.data)));
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
          color: i == selecionado ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
              color: Colors.green, width: 1.0, style: BorderStyle.solid),
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
            style: TextStyle(
                fontStyle: FontStyle.italic, color: Colors.green[900]),
          ),
        ),
      ));
    }
    return l;
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
