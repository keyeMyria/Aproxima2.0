import 'package:aproxima/Helpers/Helpers.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';

class PickLocationController extends BlocBase {
  LatLng latlng;
  BehaviorSubject<LatLng> _controllerLocation = new BehaviorSubject<LatLng>();

  Stream<LatLng> get outLocation => _controllerLocation.stream;

  Sink<LatLng> get inLocation => _controllerLocation.sink;

  int option;

  BehaviorSubject<int> _controllerOption = new BehaviorSubject<int>();

  Stream<int> get outOption => _controllerOption.stream;

  Sink<int> get inOption => _controllerOption.sink;
  double zoom = 17;
  BehaviorSubject<double> _controllerZoom = new BehaviorSubject<double>();
  Stream<double> get outZoom => _controllerZoom.stream;
  Sink<double> get inZoom => _controllerZoom.sink;
  @override
  void dispose() {
    _controllerLocation.close();
    _controllerOption.close();
    _controllerZoom.close();
  }

  PickLocationController() {
    inZoom.add(zoom);
    if (option == null) {
      option = 999;
    }
    inOption.add(option);
    if (latlng == null) {
      latlng = new LatLng(Helpers.user.cidade.lat, Helpers.user.cidade.lng);
      inLocation.add(latlng);
    }
  }
}

PickLocationController plc = new PickLocationController();
