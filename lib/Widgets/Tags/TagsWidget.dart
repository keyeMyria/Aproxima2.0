import 'package:aproxima/Objetos/Tag.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:aproxima/Widgets/Tags/TagsController.dart';
import 'package:flutter/material.dart';

class TagsWidget extends StatefulWidget {
  bool EditarProtocolo;
  List<Tagss> tags;
  TagsWidget({this.EditarProtocolo = false, this.tags});

  @override
  _TagsWidgetState createState() => new _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  Color c = Colors.green;
  @override
  Widget build(BuildContext context) {
    EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
    // TODO: implement build
    if (widget.tags != null) {
      tc.setSelectedTags(widget.tags);
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
            stream: tc.outTags,
            builder: (context, AsyncSnapshot<List<Tag>> snap) {
              if (snap.hasData) {
                return PopupMenuButton(
                    onSelected: (t) {
                      print('TAGGG ${t.toString()}');
                      tc.addToSelectedTag(t);
                    },
                    itemBuilder: (contex) {
                      List<PopupMenuItem> itens = new List();
                      for (Tag t in snap.data) {
                        itens.add(PopupMenuItem(
                          value: t,
                          child: Text(t.tag_nome),
                        ));
                      }
                      return itens;
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: c,
                          size: 35,
                        ),
                        Text(
                          widget.EditarProtocolo
                              ? 'Editar Assunto'
                              : 'Adicionar Assunto',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: c),
                        )
                      ],
                    ));
              } else {
                return Container(
                  width: 1,
                  height: 1,
                );
              }
            },
          ),
          Container(
              child: SingleChildScrollView(
            child: StreamBuilder(
              builder: (context, AsyncSnapshot<List<Tag>> snap) {
                if (snap.hasData) {
                  return Wrap(
                      children:
                          List<Widget>.generate(snap.data.length, (int index) {
                    return Padding(
                        padding: EdgeInsets.only(top: 2, left: 7),
                        child: ChoiceChip(
                          selected: true,
                          selectedColor: Colors.white,
                          onSelected: (t) {
                            tc.removeSelectedTag(snap.data[index]);
                          },
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: c,
                                  style: BorderStyle.solid,
                                  width: 0.3)),
                          label: Text(
                            '#${snap.data[index].tag_nome}',
                            style: TextStyle(
                              color: c,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ));
                  }));
                } else {
                  return Container(
                    width: 1,
                    height: 1,
                  );
                }
              },
              stream: tc.outSelectedTags,
            ),
          )),
        ]);
  }
}
