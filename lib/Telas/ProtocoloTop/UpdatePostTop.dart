import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:aproxima/Telas/ProtocoloTop/UpdatePostTopController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class UpdatePostTop extends StatefulWidget {
  Protocolo p;
  List<UpdateProtocolo> u;
  UpdatePostTop(this.u, this.p);
  _UpdatePostTopState createState() => _UpdatePostTopState();
}

class _UpdatePostTopState extends State<UpdatePostTop> {
  Color getStatusColor(String status) {
    Color c;
    print('StatusAAAAA: ${status}');
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

  UpdatePostTopController upc;
  @override
  Widget build(BuildContext context) {
    print('AQUI FDP01${widget.u.toString()}');
    upc = new UpdatePostTopController(widget.u);
    return Container(
        height: widget.u != null ? MediaQuery.of(context).size.height * .25 : 1,
        child: StreamBuilder<List<UpdateProtocolo>>(
            stream: upc.outUpdate,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Swiper(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 2.0,
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  //profileColumn(context, post),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10, bottom: 10),
                                  child: Text(
                                    snapshot.data[index].descricao,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10, bottom: 10),
                                  child: Text(snapshot.data[index].titulo,
                                      style: TextStyle(
                                          color: getStatusColor(
                                            snapshot
                                                .data[index].status.descricao,
                                          ),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, bottom: 10),
                                    child: Text(
                                        '${snapshot.data[index].created_at.day.toString()}/${snapshot.data[index].created_at.month.toString()}/${snapshot.data[index].created_at.year.toString()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15))),
                              ]));
                        }));
              } else {
                return Container();
              }
            }));
  }
}
