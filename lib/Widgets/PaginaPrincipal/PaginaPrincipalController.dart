import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class PagesController implements BlocBase {
  BehaviorSubject<int> _controllerPage = new BehaviorSubject<int>();

  Stream<int> get outPageController => _controllerPage.stream;

  Sink<int> get inPageController => _controllerPage.sink;
  @override
  void dispose() {
    _controllerPage.close();
  }

  PagesController(int page) {
    inPageController.add(page);
  }
}
