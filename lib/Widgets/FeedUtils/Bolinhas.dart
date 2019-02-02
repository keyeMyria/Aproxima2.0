import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BolinhasController implements BlocBase {
  Offset offset;
  double scale;
  int action = 0;
  BolinhasController(int total, int selecionada, {this.offset, this.scale}) {
    inTotal.add(total);
    inSelecionado.add(selecionada);
    if (offset != null) {
      inOffset.add(offset);
    }
    if (scale != null) {
      inScale.add(scale);
    }
  }
  BehaviorSubject<double> _controllerScale = new BehaviorSubject<double>();
  Stream<double> get outScale => _controllerScale.stream;

  Sink<double> get inScale => _controllerScale.sink;

  BehaviorSubject<int> _controllerTotal = new BehaviorSubject<int>();
  BehaviorSubject<int> _controllerSelecionado = new BehaviorSubject<int>();

  Stream<int> get outTotal => _controllerTotal.stream;

  Sink<int> get inTotal => _controllerTotal.sink;

  Stream<int> get outSelecionado => _controllerSelecionado.stream;

  Sink<int> get inSelecionado => _controllerSelecionado.sink;

  BehaviorSubject<Offset> _controllerOffset = new BehaviorSubject<Offset>();
  Stream<Offset> get outOffset => _controllerOffset.stream;
  Sink<Offset> get inOffset => _controllerOffset.sink;
  BehaviorSubject<int> _controllerAction = new BehaviorSubject<int>();
  Stream<int> get outAction => _controllerAction.stream;
  Sink<int> get inAction => _controllerAction.sink;
  @override
  void dispose() {
    _controllerTotal.close();
    _controllerSelecionado.close();
  }
}
