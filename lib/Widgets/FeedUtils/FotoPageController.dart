import 'package:aproxima/Objetos/Foto.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class FotoPageController implements BlocBase {
  List<Foto> Fotos;
  BehaviorSubject<List<Foto>> _controllerFotoPage =
      new BehaviorSubject<List<Foto>>();

  Stream<List<Foto>> get outFotoPage => _controllerFotoPage.stream;

  Sink<List<Foto>> get inFotoPage => _controllerFotoPage.sink;

  @override
  void dispose() {
    _controllerFotoPage.close();
  }
}
