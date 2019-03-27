import 'package:aproxima/Objetos/Comentario.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/subjects.dart';

class ComentarioController implements BlocBase {
  BehaviorSubject<List<Comentario>> _controllerComentarioPage =
      new BehaviorSubject<List<Comentario>>();
  List<Comentario> comentarios;
  DatabaseReference _comentarioRef;
  Protocolo p;
  BehaviorSubject<Protocolo> _controllerProtocolo =
      new BehaviorSubject<Protocolo>();
  Stream<Protocolo> get outProtocolo => _controllerProtocolo.stream;
  Sink<Protocolo> get inProtocolo => _controllerProtocolo.sink;
  ComentarioController(Protocolo p) {
    if (comentarios == null) {
      comentarios = new List();
    }
    this.p = p;
    _comentarioRef = FirebaseDatabase.instance
        .reference()
        .child('Protocolos')
        .child(p.id.toString())
        .child('Comentarios');
    _comentarioRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        for (var v in snapshot.value.values) {
          comentarios.add(new Comentario.toJson(v));
          inComentarioPage.add(comentarios);
        }
      }
    });
    _controllerProtocolo.add(p);
  }

  Stream<List<Comentario>> get outComentarioPage =>
      _controllerComentarioPage.stream;

  Sink<List<Comentario>> get inComentarioPage => _controllerComentarioPage.sink;

  @override
  void dispose() {
    _controllerComentarioPage.close();
    _controllerProtocolo.close();
  }

  void addComment(Comentario c) {
    _comentarioRef.push().set(c.toMap()).then((d) {
      print('Foi');
    }).catchError((err) {
      print('error: ${err.toString}');
    });
  }
}
