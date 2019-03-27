import 'dart:convert';

import 'package:aproxima/Objetos/Tag.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class TagsController implements BlocBase {
  static List<Tag> tags;
  Tag SelectedTag;
  BehaviorSubject<List<Tag>> _controllerTags = new BehaviorSubject<List<Tag>>();

  Stream<List<Tag>> get outTags => _controllerTags.stream;

  Sink<List<Tag>> get inTags => _controllerTags.sink;

  BehaviorSubject<Tag> _controllerSelectedTags = new BehaviorSubject<Tag>();

  Stream<Tag> get outSelectedTag => _controllerSelectedTags.stream;

  Sink<Tag> get inSelectedTag => _controllerSelectedTags.sink;
  @override
  void dispose() {
    _controllerTags.close();
    _controllerSelectedTags.close();
  }

  addToSelectedTag(Tag tag) {
    for (Tag t in tags) {
      if (t.id == tag.id) {
        t.isSelected = true;
      } else {
        t.isSelected = false;
      }
    }
    SelectedTag = tag;
    tags.sort((a, b) => a.tag_nome.compareTo(b.tag_nome));
    inTags.add(tags);
  }

  TagsController() {
    if (tags == null) {
      tags = new List();
      //TODO alterar id da cidade de acordo com a cidade do usuario
      http
          .get(
              'http://www.aproximamais.net/webservice/json.php?buscartags=true')
          .then((response) {
        var j = json.decode(response.body);
        for (var v in j) {
          print('TAGG ${v.toString()}');
          Tag t = new Tag.fromJson(v);
          t.isSelected = false;
          tags.add(t);
        }
        inTags.add(tags);
      });
    } else {
      inTags.add(tags);
    }
  }

  void removeSelectedTag(Tag tag) {
    for (Tag t in tags) {
      if (t.id == tag.id) {
        t.isSelected = false;
      }
    }
    SelectedTag = null;
    tags.sort((a, b) => a.tag_nome.compareTo(b.tag_nome));
    inTags.add(tags);
  }
}

TagsController tc = new TagsController();
