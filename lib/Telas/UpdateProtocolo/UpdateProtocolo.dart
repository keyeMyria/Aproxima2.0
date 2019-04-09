import 'dart:convert';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Status.dart';
import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:aproxima/Telas/Comentario/ComentarioController.dart';
import 'package:aproxima/Telas/UpdateProtocolo/UpdateProtocoloController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddUpdateProtocolo {
  var controller = new MaskedTextController(mask: '000', text: '1');
  UpdateProtocoloController upc;
  int selected;
  TextEditingController descricaoController = new TextEditingController();

  void showDialogUpdate(Protocolo p, context, ComentarioController cpc) {
    upc = new UpdateProtocoloController(p);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              shape: Border.all(),
              title: new Text(
                'Gostaria de reportar uma novidade?',
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    print('CLICOU FDP');
                    if (selected != null) {
                      //Navigator.of(context).pop();
                      ShowDialogUpdate2(context, selected, cpc);
                    } else {
                      upc.inThrowError
                          .add('É Nescessario selecionar uma Opção');
                    }
                  },
                  child: Text(
                    'Continuar',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                )
              ],
              content: StreamBuilder(
                stream: upc.outUpdateProtocolo,
                builder: (BuildContext context,
                    AsyncSnapshot<UpdateProtocolo> snapshot) {
                  return new Container(
                      child: StreamBuilder(
                          stream: upc.outSelectedStatus,
                          builder:
                              (context, AsyncSnapshot<int> selectedOption) {
                            if (selectedOption.hasData) {
                              selected = selectedOption.data;
                            }
                            return SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                  StreamBuilder(
                                    stream: upc.outThrowError,
                                    builder: (context, error) {
                                      if (error.hasData) {
                                        return Text(
                                          error.data,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontStyle: FontStyle.italic),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' Siga os passos abaixo',
                                              style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                        text:
                                            'Aqui você pode atualizar o status deste Relato e notificar à todos os interessados a atual situação do problema.'),
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Radio(
                                          activeColor: Colors.blue[900],
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.padded,
                                          groupValue: selectedOption.data,
                                          onChanged: _handleRadioValueChange,
                                          value: 1,
                                        ),
                                        Expanded(
                                            child: Text.rich(
                                          TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: '  (',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: 'Aguardando',
                                                    style: TextStyle(
                                                        color: Colors.lightBlue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: ')',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                              text:
                                                  'Precisamos resolver esse problema'),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black),
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                        )),
                                      ]),
                                  Text.rich(
                                    TextSpan(
                                        children: <TextSpan>[],
                                        text:
                                            'Marque está opção se o problema não estiver sendo resolvido'),
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Radio(
                                          activeColor: Colors.blue[900],
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.padded,
                                          groupValue: selectedOption.data,
                                          onChanged: _handleRadioValueChange,
                                          value: 3,
                                        ),
                                        Expanded(
                                            child: Text.rich(
                                          TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: '  (',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: 'Em Andamento',
                                                    style: TextStyle(
                                                        color: Colors.lightBlue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: ')',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                              text:
                                                  'Este problema está sendo resolvido'),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black),
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                        )),
                                      ]),
                                  Text.rich(
                                    TextSpan(
                                        children: <TextSpan>[],
                                        text:
                                            'Marque está opção se o problema estiver sendo resolvido'),
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Radio(
                                          activeColor: Colors.blue[900],
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.padded,
                                          groupValue: selectedOption.data,
                                          onChanged: _handleRadioValueChange,
                                          value: 4,
                                        ),
                                        Expanded(
                                            child: Text.rich(
                                          TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: '  (',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: 'Concluído',
                                                    style: TextStyle(
                                                        color: Colors.lightBlue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: ')',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                              text:
                                                  'Este problema ja foi concluído'),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black),
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                        )),
                                      ]),
                                  Text.rich(
                                    TextSpan(
                                        children: <TextSpan>[],
                                        text:
                                            'Marque está opção se o problema já tiver sido resolvido'),
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                ]));
                          }));
                },
              ));
        });
  }

  void _handleRadioValueChange(int value) {
    upc.inThrowError.add(null);
    upc.inSelectedStatus.add(value);
  }

  void ShowDialogUpdate2(
      BuildContext context, int selected, ComentarioController cpc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              shape: Border.all(),
              title: new Text(
                'Descreva a Situação atual',
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Status s;
                    switch (selected) {
                      case 0:
                        break;
                      case 1:
                        s = Status(1, 'Enviado');
                        break;
                      case 3:
                        s = Status(3, 'Em Andamento');
                        break;
                      case 4:
                        s = Status(4, 'Concluído');
                        break;
                      case 5:
                        break;
                    }
                    UpdateProtocolo up = new UpdateProtocolo(
                        0,
                        Helpers.user.id,
                        descricaoController.text,
                        '',
                        DateTime.now(),
                        DateTime.now(),
                        null,
                        Helpers.user.nome,
                        '0',
                        upc.p.id.toString(),
                        selected.toString(),
                        s,
                        Helpers.user);
                    upc.inUpdateProtocolo.add(up);
                    upc.RegistrarUpdate(up).then((p) {
                      if (p != null) {
                        Helpers.nh.sendNotification({
                          'title':
                              '${Helpers.user.nome} Atualizou o Relato ${p.titulo}, para ${p.status.descricao}',
                          'responsavel': json.encode(Helpers.user),
                          'tipo': 0.toString(),
                          'sujeito': p.id.toString(),
                          'topic': 'protocoloteste' + p.id.toString(),
                          'foto': Helpers.user.foto == null
                              ? 'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'
                              : Helpers.user.foto,
                          'data':
                              DateTime.now().millisecondsSinceEpoch.toString(),
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                    });
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                )
              ],
              content: new Container(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                TextField(
                    controller: descricaoController,
                    maxLength: 140,
                    autocorrect: true,
                    cursorColor: Colors.blue[900],
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      helperText: 'Uma Breve Descrição do que está sendo feito',
                      hintText: 'O problema está sendo resolvido',
                      counterStyle: TextStyle(
                        color: Colors.blue[900],
                      ),
                    ))
              ])));
        });
  }
}
