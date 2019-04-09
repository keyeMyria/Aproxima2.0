import 'package:aproxima/Helpers/Choise.dart';
import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Secretaria.dart';
import 'package:aproxima/Widgets/FeedUtils/Feed.dart';
import 'package:aproxima/Widgets/ModoLista/ModoListaController.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ModoListaWidget extends StatefulWidget {
  @override
  _ModoListaWidgetState createState() => _ModoListaWidgetState();
}

class _ModoListaWidgetState extends State<ModoListaWidget> {
  ModoListaController mlc = ModoListaController();

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text(Helpers.user.cidade.cidade);
  FocusNode myFocusNode;

  @override
  initState() {
    {
      super.initState();
    }
    // TODO: implement initState
    super.initState();
  }

  String x = 'a';

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * .1),
            child: StreamBuilder(
                stream: mlc.outIsFiltering,
                builder: (context, snap) {
                  if (snap.hasData) {
                    return new AppBar(
                        backgroundColor: Colors.white,
                        title: snap.data
                            ? new TextField(
                                style: TextStyle(color: Helpers.blue_default),
                                controller: _filter,
                                focusNode: myFocusNode,
                                onEditingComplete: () {
                                  mlc.UpdateFilter(true);
                                  mlc.StartFilter(
                                    filtertext: _filter.text,
                                  );
                                },
                                onSubmitted: (s) {
                                  mlc.UpdateFilter(true);
                                  mlc.StartFilter(
                                    filtertext: _filter.text,
                                  );
                                },
                                decoration: new InputDecoration(
                                    suffixIcon: new IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: Helpers.blue_default,
                                        ),
                                        onPressed: () {
                                          mlc.UpdateFilter(true);
                                          mlc.StartFilter(
                                            filtertext: _filter.text,
                                          );
                                        }),
                                    hintText: 'Procurar...',
                                    hintStyle:
                                        TextStyle(color: Helpers.blue_default)),
                              )
                            : new Text(
                                Helpers.user.cidade.cidade,
                                style: TextStyle(color: Helpers.blue_default),
                              ),
                        leading: IconButton(
                            icon: snap.data
                                ? Icon(
                                    Icons.close,
                                    color: Helpers.blue_default,
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Helpers.blue_default,
                                  ),
                            onPressed: () {
                              if (snap.data == true) {
                                filteredNames = names;
                                _filter.clear();
                                mlc.UpdateFilter(false);
                                mlc.StartFilter();
                              } else {
                                mlc.inIsFiltering.add(true);
                              }
                            }),
                        actions: [
                          StreamBuilder(builder: (context, snap) {
                            return IconButton(
                              icon: Icon(
                                Icons.date_range,
                                color: Helpers.blue_default,
                              ),
                              onPressed: () async {
                                final List<DateTime> picked =
                                    await DateRagePicker.showDatePicker(
                                        context: context,
                                        initialFirstDate: new DateTime.now(),
                                        initialLastDate: (new DateTime.now())
                                            .add(new Duration(days: 7)),
                                        firstDate: new DateTime(2015),
                                        lastDate: new DateTime(2020));
                                if (picked != null && picked.length == 2) {
                                  mlc.UpdateFilterByDate(true);
                                  mlc.StartFilter(d1: picked[0], d2: picked[1]);
                                }
                              },
                            );
                          }),
                          PopupMenuButton<Choice>(
                            icon: Icon(
                              Icons.filter_list,
                              color: Helpers.blue_default,
                            ),
                            onSelected: (choise) {
                              mlc.UpdateFilterByStatus(true);
                              mlc.StartFilter(c: choise);
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
                              stream: mlc.outSecretarias,
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return PopupMenuButton<Secretaria>(
                                    icon: Icon(Icons.local_printshop,
                                        color: Helpers.blue_default),
                                    onSelected: (choise) {
                                      mlc.UpdateFilterBySecretaria(true);
                                      mlc.StartFilter(s: choise);
                                    },
                                    itemBuilder: (BuildContext context) {
                                      List<PopupMenuItem<Secretaria>> itens =
                                          new List();
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
        body: StreamBuilder<List<Protocolo>>(
            stream: mlc.outModoLista,
            builder: (BuildContext context,
                AsyncSnapshot<List<Protocolo>> snapshot) {
              if (snapshot.data != null) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Stack(children: <Widget>[
                      new ListView.builder(
                        itemBuilder: (context, index) {
                          return ActivityFeedItem(
                            protocolo: snapshot.data[index],
                            type: 'comment',
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.info),
                            color: Helpers.green_default,
                            onPressed: () {
                              mlc.outshowFilters.first.then((b) {
                                mlc.UpdateShowFilters(!b);
                              });
                            },
                          ),
                          StreamBuilder(
                            initialData: false,
                            stream: mlc.outshowFilters,
                            builder: (context, s) {
                              if (s.hasData) {
                                if (s.data) {
                                  return Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          color:
                                              Color.fromARGB(60, 160, 160, 160),
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
                                                            color: Colors.black,
                                                            fontSize: 16));
                                                  case 1:
                                                    return StreamBuilder(
                                                      stream:
                                                          mlc.outIsFiltering,
                                                      initialData: false,
                                                      builder: (context, snap) {
                                                        if (snap.hasData) {
                                                          if (snap.data &&
                                                              mlc.filtertext !=
                                                                  '') {
                                                            return Text(
                                                                'Palavra chave: ${mlc.filtertext}',
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
                                                      stream: mlc
                                                          .outIsFilteringByDate,
                                                      initialData: false,
                                                      builder: (context, snap) {
                                                        if (s.hasData) {
                                                          if (snap.data) {
                                                            return Text(
                                                                'De:   ${mlc.d1.day} /${mlc.d1.month}/${mlc.d1.year} A:  ${mlc.d2.day} /${mlc.d2.month}/${mlc.d2.year}',
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
                                                      stream: mlc
                                                          .outisFilteringByStatus,
                                                      initialData: false,
                                                      builder: (context, snap) {
                                                        if (snap.hasData) {
                                                          if (snap.data) {
                                                            if (mlc.c != null) {
                                                              return Text(
                                                                  'Status:   ${mlc.c.title}',
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
                                                      stream: mlc
                                                          .outisFilteringBySecretaria,
                                                      initialData: false,
                                                      builder: (context, snap) {
                                                        if (snap.hasData) {
                                                          if (snap.data) {
                                                            return Text(
                                                                'Status:   ${mlc.s.nome}',
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
                                                          Helpers.green_default,
                                                      onPressed: () {
                                                        mlc.UpdateFilterBySecretaria(
                                                            false);
                                                        mlc.UpdateFilter(false);
                                                        mlc.UpdateFilterByStatus(
                                                            false);
                                                        mlc.UpdateFilterByDate(
                                                            false);
                                                        mlc.UpdateShowFilters(
                                                            false);
                                                        mlc.StartFilter();
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
                    ]));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Carregando Dados',
                      style: TextStyle(
                          color: Helpers.green_default, fontSize: 32.0),
                    ),
                    SpinKitThreeBounce(
                      color: Helpers.green_default,
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

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('AproximA+'),
      leading: Container(
        width: 0,
        height: 0,
      ), //searchBar.getSearchAction(context),
      /*actions: [
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
        ]*/
    );
  }
}
