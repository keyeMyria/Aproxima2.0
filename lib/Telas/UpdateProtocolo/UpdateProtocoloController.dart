import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/UpdateProtocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class UpdateProtocoloController implements BlocBase {
  Protocolo p;

  UpdateProtocoloController(this.p);

  BehaviorSubject<UpdateProtocolo> _controllerUpdateProtocolo =
      new BehaviorSubject<UpdateProtocolo>();

  Stream<UpdateProtocolo> get outUpdateProtocolo =>
      _controllerUpdateProtocolo.stream;

  Sink<UpdateProtocolo> get inUpdateProtocolo =>
      _controllerUpdateProtocolo.sink;

  @override
  void dispose() {
    _controllerUpdateProtocolo.close();
  }
}
