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
  Color c = Colors.blue;
  @override
  Widget build(BuildContext context) {
    EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
    // TODO: implement build
    if (widget.tags != null) {
      tc.addToSelectedTag(widget.tags[0].tag);
    }
    return StreamBuilder(
      stream: tc.outTags,
      builder: (context, AsyncSnapshot<List<Tag>> snap) {
        if (snap.hasData) {
          return Container(
              height: MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children:
                      List<Widget>.generate(snap.data.length, (int index) {
                    return Padding(
                        padding: EdgeInsets.only(top: 2, left: 7),
                        child: ChoiceChip(
                          selected: snap.data[index].isSelected,
                          selectedColor: Colors.blue,
                          onSelected: (t) {
                            tc.addToSelectedTag(snap.data[index]);
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
                                color: snap.data[index].isSelected
                                    ? Colors.white
                                    : c,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ));
                  })));
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
