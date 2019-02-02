import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class UpdatePostTopController implements BlocBase {
  List<UpdateProtocolo> lista;

  UpdatePostTopController(this.lista) {
    inUpdate.add(lista);
  }

  BehaviorSubject<List<UpdateProtocolo>> _controllerUpdate =
      new BehaviorSubject<List<UpdateProtocolo>>();

  Stream<List<UpdateProtocolo>> get outUpdate => _controllerUpdate.stream;

  Sink<List<UpdateProtocolo>> get inUpdate => _controllerUpdate.sink;

  @override
  void dispose() {
    _controllerUpdate.close();
  }
}
