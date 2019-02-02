import 'dart:convert';

import 'package:aproxima/Objetos/Tag.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class TagsController implements BlocBase {
  static List<Tag> tags;
  List<Tag> SelectedTags;
  BehaviorSubject<List<Tag>> _controllerTags = new BehaviorSubject<List<Tag>>();

  Stream<List<Tag>> get outTags => _controllerTags.stream;

  Sink<List<Tag>> get inTags => _controllerTags.sink;

  BehaviorSubject<List<Tag>> _controllerSelectedTags =
      new BehaviorSubject<List<Tag>>();

  Stream<List<Tag>> get outSelectedTags => _controllerSelectedTags.stream;

  Sink<List<Tag>> get inSelectedTags => _controllerSelectedTags.sink;
  @override
  void dispose() {
    _controllerTags.close();
    _controllerSelectedTags.close();
  }

  addToSelectedTag(Tag t) {
    if (SelectedTags == null) {
      SelectedTags = new List();
    }
    bool contains = false;
    for (Tag tt in SelectedTags) {
      if (tt.id == t.id) {
        contains = true;
      }
    }
    if (!contains) {
      SelectedTags.add(t);
      SelectedTags.sort((a, b) => a.tag_nome.compareTo(b.tag_nome));
      inSelectedTags.add(SelectedTags);
      for (Tag tt in tags) {
        if (tt.id == t.id) {
          tags.remove(tt);
        }
      }
      tags.sort((a, b) => a.tag_nome.compareTo(b.tag_nome));
      inTags.add(tags);
    }
  }

  TagsController() {
    if (SelectedTags == null) {
      SelectedTags = new List();
    }
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
          tags.add(new Tag.fromJson(v));
        }
        inTags.add(tags);
      });
    } else {
      inTags.add(tags);
    }
  }

  void removeSelectedTag(Tag t) {
    SelectedTags.remove(t);
    SelectedTags.sort((a, b) => a.tag_nome.compareTo(b.tag_nome));
    inSelectedTags.add(SelectedTags);
    tags.add(t);
    tags.sort((a, b) => a.tag_nome.compareTo(b.tag_nome));
    inTags.add(tags);
  }

  void setSelectedTags(List<Tagss> tags) {
    SelectedTags = new List();
    for (Tagss t in tags) {
      addToSelectedTag(t.tag);
    }
  }
}

TagsController tc = new TagsController();
