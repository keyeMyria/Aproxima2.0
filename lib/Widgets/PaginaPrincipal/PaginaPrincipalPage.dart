import 'package:aproxima/Helpers/BadgerController.dart';
import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Cidade.dart';
import 'package:aproxima/Objetos/Estado.dart';
import 'package:aproxima/Objetos/Pais.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/AdicionarProtocolo/AdicionarProtocoloPage.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:aproxima/Telas/Mapa/Mapa.dart';
import 'package:aproxima/Telas/News/NewsPage.dart';
import 'package:aproxima/Telas/UserProfile/friend_details_page.dart';
import 'package:aproxima/Widgets/ModoLista/ModoListaController.dart';
import 'package:aproxima/Widgets/ModoLista/ModoListaWidgets.dart';
import 'package:aproxima/Widgets/PaginaPrincipal/PaginaPrincipalController.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class ModoListaPage extends StatefulWidget {
  _ModoListaPageState createState() => _ModoListaPageState();
}

class _ModoListaPageState extends State<ModoListaPage> {
  ModoListaController mlc = ModoListaController();

  final PagesController pc = new PagesController(1);
  bool openedDL = false;

  PageController pageController;
  int page = 1;
  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: this.page, keepPage: true);
  }

  var page1;
  Cidade castro = new Cidade('Castro', 0, 0, 0.0, 0.0,
      new Estado('Paraná', 0, 'PR', 0, new Pais(0, 'Brasil', 'Br')));

  User u;
  var page0 = Container(
    child: NewsPage(),
  );
  final page2 = Container(child: Mapa());
  var page3;
  bool openNews = true;
  Color c = Colors.black87;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    page1 = Container(
      child: ModoListaWidget(),
    );
    page3 = Container(
        child: FriendDetailsPage(Helpers.user, false, 0,
            avatarTag: Helpers.user.id.toString() + Helpers.user.nome,
            isuser: true));
    FirebaseDynamicLinks.instance.retrieveDynamicLink().then((v) {
      print('AQUI DINAMIC LINK DEMONIO');
      Uri deepLink = null;
      if (v != null) {
        deepLink = v.link;
      }
      print('AQUI BUSCANDO' + deepLink.toString());

      if (deepLink != null) {
        var a = deepLink.path.split('/');
        print('DEEP LINK ' + a.toString());
        print(a.last);
        if (!openedDL) {
          mlc.getProtocoloFromDL(a.last).then((p) {
            if (p != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ComentarioPage(p)));
              openedDL = true;
            }
          }).catchError((err) {
            print('Error: ${err.toString()}');
          });
        }
      }
    });
    return StreamBuilder<int>(
        stream: pc.outPageController,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != null) {
            return WillPopScope(
                onWillPop: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          shape: Border.all(),
                          title: new Text('Deseja Sair?'),
                          content: Text('Tem Certeza?'),
                          actions: <Widget>[
                            MaterialButton(
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            MaterialButton(
                              child: Text(
                                'Sair',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                            )
                          ],
                        );
                      });
                },
                child: Scaffold(
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    floatingActionButton: FloatingActionButton(
                      tooltip: 'Adicionar Relato',
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdicionarProtocoloPage(),
                            ));
                      },
                    ),
                    key: scaffoldKey,
                    backgroundColor: Colors.white,
                    body: PageView(
                        physics: snapshot.data == 2
                            ? NeverScrollableScrollPhysics()
                            : BouncingScrollPhysics(),
                        children: [page0, page1, page2, page3],
                        controller: pageController,
                        onPageChanged: onPageChanged),
                    bottomNavigationBar: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        color: Colors.blue,
                        child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              snapshot.data == 0
                                  ? IconButton(
                                      tooltip: 'Novidades',
                                      icon: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          snapshot.data == 0
                                              ? Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor:
                                                      Colors.grey[500],
                                                  child:
                                                      Icon(Icons.notifications))
                                              : Icon(Icons.notifications),
                                          Positioned(
                                            child: StreamBuilder(
                                                stream: bc.outBadge,
                                                builder: (context, snap) {
                                                  return snap.data != 0
                                                      ? Container(
                                                          width: 20,
                                                          height: 20,
                                                          child: Center(
                                                            child: Text(
                                                              snap.data
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .red),
                                                        )
                                                      : Container();
                                                }),
                                            right: 0,
                                            top: 0,
                                          ),
                                        ],
                                      ),
                                      color:
                                          snapshot.data == 0 ? c : Colors.white,
                                      iconSize: 35,
                                      onPressed: () {
                                        onTap(0);
                                        bc.removeBadges();
                                      },
                                    )
                                  : IconButton(
                                      tooltip: 'Novidades',
                                      icon: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Icon(Icons.notifications),
                                          Positioned(
                                            child: StreamBuilder(
                                                stream: bc.outBadge,
                                                builder: (context, snap) {
                                                  return snap.data != 0
                                                      ? Container(
                                                          width: 20,
                                                          height: 20,
                                                          child: Center(
                                                            child: Text(
                                                              snap.data
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .red),
                                                        )
                                                      : Container();
                                                }),
                                            right: 0,
                                            top: 0,
                                          ),
                                        ],
                                      ),
                                      color: Colors.white,
                                      iconSize: 35,
                                      onPressed: () {
                                        onTap(0);
                                        bc.removeBadges();
                                      },
                                    ),
                              snapshot.data == 1
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey[500],
                                      child: IconButton(
                                        tooltip: 'Feed de Relatos',
                                        icon: new Icon(Icons.dehaze),
                                        color: Colors.white,
                                        iconSize: 35,
                                        onPressed: () => onTap(1),
                                      ))
                                  : IconButton(
                                      tooltip: 'Feed de Relatos',
                                      icon: new Icon(Icons.dehaze),
                                      color: Colors.white,
                                      iconSize: 35,
                                      onPressed: () => onTap(1),
                                    ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                              snapshot.data == 2
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey[500],
                                      child: IconButton(
                                        tooltip: 'Mapa da Cidade',
                                        icon: new Icon(Icons.map),
                                        color: Colors.white,
                                        iconSize: 35,
                                        onPressed: () => onTap(2),
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: 'Mapa da Cidade',
                                      icon: new Icon(Icons.map),
                                      color: Colors.white,
                                      iconSize: 35,
                                      onPressed: () => onTap(2),
                                    ),
                              snapshot.data == 3
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey[500],
                                      child: IconButton(
                                        tooltip: 'Perfil',
                                        icon: new Icon(Icons.people),
                                        color: Colors.white,
                                        iconSize: 35,
                                        onPressed: () => onTap(3),
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: 'Perfil',
                                      icon: new Icon(Icons.people),
                                      color: Colors.white,
                                      iconSize: 35,
                                      onPressed: () => onTap(3),
                                    )

                              /*new BottomNavigationBarItem(
                              icon: new Icon(Icons.location_on),
                              title: new Text("Mapa")),
                          new BottomNavigationBarItem(
                              icon: new Icon(Icons.account_circle),
                              title: new Text("Perfil"))*/
                            ]))));
          } else {
            return Container(
              width: 40,
              height: 40,
            );
          }
        });
  }

  void onTap(int index) {
    pc.inPageController.add(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    pc.inPageController.add(page);
  }
}
