import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgerController extends BlocBase {
  String _appBadgeSupported = 'Unknown';
  BehaviorSubject<int> _controllerBadge = new BehaviorSubject<int>();

  Stream<int> get outBadge => _controllerBadge.stream;

  Sink<int> get inBadge => _controllerBadge.sink;

  BadgerController() {
    initPlatformState();
    SharedPreferences.getInstance().then((prefs) {
      int badges = prefs.getInt('badges');
      if (badges == null) {
        badges = 0;
      }
      // FlutterAppBadger.updateBadgeCount(badges);
      inBadge.add(badges);
    });
  }

  initPlatformState() async {
    /* try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        Helpers.appBadgeSupported = 'Supported';
      } else {
        Helpers.appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      Helpers.appBadgeSupported = 'Failed to get badge support.';
    }
    print('Suported : ${Helpers.appBadgeSupported}');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    //setState(() {
    _appBadgeSupported = Helpers.appBadgeSupported;*/

    //});
  }

  Future addBadge() async {
    initPlatformState();
    print('Iniciando ADD BADGE');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int badges = prefs.getInt('badges');
    if (badges == null) {
      badges = 0;
    }
    badges++;
    //FlutterAppBadger.updateBadgeCount(badges);
    prefs.setInt('badges', badges);
    inBadge.add(badges);
    print('ADICIONOU BADGE ${badges}');
  }

  Future removeBadges() async {
    initPlatformState();
    print('Iniciando ADD BADGE');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int badges = prefs.getInt('badges');
    if (badges == null) {
      badges = 0;
    }
    badges = 0;
    //FlutterAppBadger.updateBadgeCount(badges);
    prefs.setInt('badges', badges);
    inBadge.add(badges);
    print('ADICIONOU BADGE ${badges}');
  }

  @override
  void dispose() {
    _controllerBadge.close();
  }
}

BadgerController bc = new BadgerController();
