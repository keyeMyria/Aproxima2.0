import 'package:aproxima/Widgets/PickLocation/PickLocationController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PickLocationWidget extends StatefulWidget {
  @override
  _PickLocationWidgetState createState() => new _PickLocationWidgetState();
}

class _PickLocationWidgetState extends State<PickLocationWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: plc.outOption,
      builder: (context, AsyncSnapshot<int> snap) {
        if (snap.hasData) {
          return Column(children: <Widget>[
            PopupMenuButton(
                onSelected: (t) {
                  print('TAGGG ${t.toString()}');
                  plc.inOption.add(t);
                },
                itemBuilder: (contex) {
                  List<PopupMenuItem> itens = new List();
                  if (snap.data != 0) {
                    itens.add(PopupMenuItem(
                      value: 0,
                      child: Text('Escolher no Mapa'),
                    ));
                  }
                  if (snap.data != 1) {
                    itens.add(PopupMenuItem(
                      value: 1,
                      child: Text('Escolher por CEP'),
                    ));
                  }
                  if (snap.data != 2) {
                    itens.add(PopupMenuItem(
                      value: 2,
                      child: Text('Escolher por Endereco'),
                    ));
                  }
                  return itens;
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 35,
                    ),
                    Text(
                      'Escolha a forma de definir o local do Relato',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 17,
                          color: Colors.blue),
                    )
                  ],
                )),
            StreamBuilder(
                stream: plc.outLocation,
                builder: (context, AsyncSnapshot<LatLng> location) {
                  switch (snap.data) {
                    case 0:
                      if (location.hasData) {
                        return StreamBuilder(
                          stream: plc.outZoom,
                          builder: (context, zoom) {
                            return GestureDetector(
                                onScaleUpdate: (details) {
                                  plc.inZoom.add(details.scale);
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                9,
                                        child: new FlutterMap(
                                          options: new MapOptions(
                                            interactive: true,
                                            onTap: (ll) {
                                              plc.inLocation.add(ll);
                                            },
                                            center: location.data,
                                            zoom: zoom.hasData ? zoom.data : 17,
                                          ),
                                          mapController: MapController(),
                                          layers: [
                                            new TileLayerOptions(
                                              urlTemplate:
                                                  "https://api.tiles.mapbox.com/v4/"
                                                  "{id}/{z}/{x}/{y}@2x.png?access_token=sk.eyJ1IjoicmJzb2Z0d2FyZSIsImEiOiJjam5xYng1aG8wMG55M3hreXJlZmVxMjA1In0.NBY7xfp9rERgMM3Ub1iwFg",
                                              additionalOptions: {
                                                'accessToken':
                                                    'sk.eyJ1IjoicmJzb2Z0d2FyZSIsImEiOiJjam5xYng1aG8wMG55M3hreXJlZmVxMjA1In0.NBY7xfp9rERgMM3Ub1iwFg',
                                                'id': 'mapbox.streets',
                                              },
                                            ),
                                            new MarkerLayerOptions(markers: [
                                              Marker(
                                                  point: location.data,
                                                  builder: (context) {
                                                    return Icon(
                                                      Icons.place,
                                                      color: Colors.blue,
                                                      size: 35,
                                                    );
                                                  })
                                            ]),
                                          ],
                                        ))));
                          },
                        );
                      } else {
                        return Container();
                      }
                      break;
                    case 1:
                      return Container(
                        width: 30,
                        height: 30,
                      );
                    case 2:
                      return Container(
                        width: 30,
                        height: 30,
                      );
                    case 999:
                      return Container(
                        width: 30,
                        height: 30,
                      );
                  }
                })
          ]);
        } else {
          return Container(
            width: 1,
            height: 1,
          );
        }
      },
    );
  }
}
