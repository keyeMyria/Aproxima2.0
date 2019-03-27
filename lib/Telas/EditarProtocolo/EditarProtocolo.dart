import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Tag.dart';
import 'package:aproxima/Telas/EditarProtocolo/EditarProtocoloController.dart';
import 'package:aproxima/Widgets/PickLocation/PickLocationController.dart';
import 'package:aproxima/Widgets/PickLocation/PickLocationWidget.dart';
import 'package:aproxima/Widgets/Tags/TagsController.dart';
import 'package:aproxima/Widgets/Tags/TagsWidget.dart';
import 'package:flutter/material.dart';

class EditarProtocolo extends StatefulWidget {
  Protocolo p;

  EditarProtocolo(this.p);

  _EditarProtocoloState createState() => _EditarProtocoloState();
}

class _EditarProtocoloState extends State<EditarProtocolo> {
  final TextEditingController tituloController =
      new TextEditingController(text: '');
  final TextEditingController descricaoController =
      new TextEditingController(text: '');
  final TextEditingController enderecoController =
      new TextEditingController(text: '');

  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 10.0, 15.0, 3.0);
  EditarProtocoloController epc;
  @override
  Widget build(BuildContext context) {
    epc = EditarProtocoloController(widget.p);
    return StreamBuilder(
      stream: epc.outEditProtocolo,
      builder: (context, AsyncSnapshot<Protocolo> snap) {
        if (snap.hasData) {
          descricaoController.text = snap.data.descricao;
          tituloController.text = snap.data.titulo;
          enderecoController.text = snap.data.endereco;
        }
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Editar Protocolo'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    applyChanges(snap.data);
                  }),
            ],
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                padding: ei,
                child: TextFormField(
                  controller: tituloController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.border_color,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid)),
                      hintText: 'Buraco',
                      labelText: 'Titulo',
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic)),
                ),
              ),
              Padding(
                  padding: ei,
                  child: TextFormField(
                    controller: descricaoController,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.rate_review,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        hintText: 'Buraco na via',
                        labelText: 'Descrição',
                        hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic)),
                  )),
              TagsWidget(
                tags: widget.p.tags,
                EditarProtocolo: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              PickLocationWidget()
            ],
          ),
        );
      },
    );
  }

  applyChanges(Protocolo p) {
    p.titulo = tituloController.text;
    p.descricao = descricaoController.text;
    plc.outLocation.first.then((latlng) {
      p.lat = latlng.latitude;
      p.lng = latlng.longitude;
      tc.outSelectedTag.first.then((tags) {
        Tag t = tags;
        epc.AtualizarProtocolo(p, t).then((b) {
          if (b) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Atualizado com sucesso'),
              backgroundColor: Colors.black,
            ));
            Navigator.of(context).pop();
          }
        });
      });
    });
  }
}
