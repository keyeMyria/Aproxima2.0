import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ControllerSnackBar implements BlocBase {
  Protocolo protocolo;
  BehaviorSubject<Protocolo> _controllerProtocolo =
      new BehaviorSubject<Protocolo>();

  ControllerSnackBar(this.protocolo) {
    inProtocolo.add(protocolo);
  }

  Stream<Protocolo> get outProtocolo => _controllerProtocolo.stream;

  Sink<Protocolo> get inProtocolo => _controllerProtocolo.sink;

  @override
  void dispose() {
    _controllerProtocolo.close();
  }
}
