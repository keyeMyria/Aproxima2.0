import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:aproxima/Telas/UpdateProtocolo/UpdateProtocoloController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddUpdateProtocolo {
  var controller = new MaskedTextController(mask: '000', text: '1');
  void showDlgConfirmacao(Protocolo p, context) {
    UpdateProtocoloController upc = new UpdateProtocoloController(p);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              shape: Border.all(),
              title: new Text(p.titulo),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {},
                  child: Text('Cancelar'),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Text('Confirmar'),
                )
              ],
              content: StreamBuilder(
                stream: upc.outUpdateProtocolo,
                builder: (BuildContext context,
                    AsyncSnapshot<UpdateProtocolo> snapshot) {
                  if (snapshot.data != null) {
                    return new Container(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          Expanded(
                            child: Text(
                              'Enviado',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]));
                  } else {
                    return Container();
                  }
                },
              ));
        });
  }
}
