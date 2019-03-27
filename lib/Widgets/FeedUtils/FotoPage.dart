import 'package:aproxima/Objetos/Foto.dart';
import 'package:aproxima/Widgets/FeedUtils/Bolinhas.dart';
import 'package:aproxima/Widgets/FeedUtils/FotoPageController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FotoPage extends StatefulWidget {
  int index;
  List<Foto> fotos;

  FotoPage({this.index, this.fotos});

  _FotoPageState createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  FotoPageController fpc = FotoPageController();
  PageController pageController;
  Offset offset;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    offset = Offset.zero;
    pageController = new PageController(
      initialPage: widget.index,
    );
    double s = .5;
    BolinhasController bc = new BolinhasController(
        widget.fotos.length, widget.index,
        offset: offset, scale: s);

    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              StreamBuilder(
                stream: bc.outOffset,
                builder: (context, off) {
                  print(off.data.toString());
                  if (off.hasData) {
                    return StreamBuilder(
                        stream: bc.outScale,
                        builder: (context, AsyncSnapshot<double> snapscale) {
                          return StreamBuilder(
                              builder: (context, action) {
                                return Positioned(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    left: off.data.dx,
                                    top: off.data.dy,
                                    child: Container(
                                      child: GestureDetector(
                                          onScaleUpdate:
                                              (ScaleUpdateDetails scale) {
                                            if (action.data == 0 ||
                                                action.data == 1) {
                                              bc.inAction.add(1);
                                              print(
                                                  'SCALING ${scale.scale}  STREAM SCALE${snapscale.data}');
                                              bc.inScale.add(scale.scale);
                                            }
                                          },
                                          onScaleEnd: (scale) {
                                            bc.inAction.add(0);
                                          },
                                          onVerticalDragUpdate: (details) {
                                            if (action.data == 0 ||
                                                action.data == 2) {
                                              bc.inAction.add(2);
                                              print(
                                                  'PEGOU DEMONIO  ${MediaQuery.of(context).size.height} ${off.data.toString()} DETAILS  ${details.delta.distance} DIRECTION ${details.delta.direction}');

                                              offset = Offset(
                                                  offset.dx,
                                                  details.globalPosition.dy -
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          2);
                                              bc.inOffset.add(offset);
                                            }
                                          },
                                          onVerticalDragEnd: (drag) {
                                            if (offset.dy <
                                                -MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4) {
                                              Navigator.of(context).pop();
                                            } else if (offset.dy >
                                                MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3) {
                                              Navigator.of(context).pop();
                                            } else {
                                              bc.inOffset.add(Offset.zero);
                                              bc.inAction.add(0);
                                            }
                                          },
                                          child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Swiper(
                                                itemCount: widget.fotos.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics: PageScrollPhysics(),
                                                onIndexChanged: (index) {
                                                  bc.inSelecionado.add(index);
                                                },
                                                itemBuilder: (contex, index) {
                                                  return PhotoView(
                                                    imageProvider:
                                                        CachedNetworkImageProvider(
                                                      widget.fotos[widget.index]
                                                          .link,
                                                    ),
                                                  );
                                                },
                                              ))),
                                    ));
                              },
                              stream: bc.outAction);
                        });
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    );
                  }
                },
              ),
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
                                            total.data, selecionado.data, bc)));
                              } else {
                                return Container();
                              }
                            }));
                      }),
                      stream: bc.outTotal, //,
                    ),
                  ))
            ])));
  }

  getFotos() {
    List<PhotoViewGalleryPageOptions> l = new List();
    for (Foto f in widget.fotos) {
      l.add(PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(f.link)));
    }
    return l;
  }

  dotList(int length, int selecionado, BolinhasController bc) {
    List<Widget> l = new List();
    for (int i = 0; i < length; i++) {
      l.add(GestureDetector(
          onTap: () {
            print('ONTAP FDP');
            pageController.jumpToPage(i);
            bc.inSelecionado.add(i);
          },
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: i == selecionado ? Colors.blue : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.blue, width: 1.0, style: BorderStyle.solid),
            ),
          )));
    }
    return l;
  }
}
