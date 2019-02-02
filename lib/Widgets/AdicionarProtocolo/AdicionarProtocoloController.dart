import 'dart:async';
import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Foto.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AdicionarProtocoloController implements BlocBase {
  bool _isCreatingLink = false;
  String _linkMessage;
  static Protocolo p;
  BehaviorSubject<Protocolo> _controllerProtocolo =
      new BehaviorSubject<Protocolo>();
  Stream<Protocolo> get outProtocolo => _controllerProtocolo.stream;

  Sink<Protocolo> get inProtocolo => _controllerProtocolo.sink;
  List<Foto> images;

  //List<Asset> imagensGaleria;
  BehaviorSubject<List<Foto>> _controllerFotos =
      new BehaviorSubject<List<Foto>>();
  Stream<List<Foto>> get outFotos => _controllerFotos.stream;
  Sink<List<Foto>> get inFotos => _controllerFotos.sink;
  BehaviorSubject<int> _controllerPage = new BehaviorSubject<int>();

  Stream<int> get outPageController => _controllerPage.stream;

  Sink<int> get inPageController => _controllerPage.sink;

  /*BehaviorSubject<List<Asset>> _controllerFotosGaleria =
      new BehaviorSubject<List<Asset>>();
  Stream<List<Asset>> get outFotosGaleria => _controllerFotosGaleria.stream;
  Sink<List<Asset>> get inFotosGaleria => _controllerFotosGaleria.sink;*/
  @override
  void dispose() {
    _controllerProtocolo.close();
    _controllerFotos.close();
    //_controllerFotosGaleria.close();
    _controllerPage.close();
  }

  AdicionarProtocoloController() {
    /*if (imagensGaleria == null) {
      imagensGaleria = new List<Asset>();
    }*/

    inPageController.add(0);
    refreshPictures();
    if (p == null) {
      p = Protocolo.Empty();
    }
    inProtocolo.add(p);
  }

  /*Future<void> _createDynamicLink(bool short, String id, Protocolo d,
      GlobalKey<ScaffoldState> _scafoldKey) async {
    _isCreatingLink = true;

    final DynamicLinkParameters parameters = new DynamicLinkParameters(
      domain: 'bartner.page.link',
      link: Uri.parse('https://bartner.page.link/VerDesejoPage' + id),
      androidParameters: new AndroidParameters(
        packageName: 'com.rbsoftware.bartner',
        minimumVersion: 0,
      ),
      iosParameters: new IosParameters(
        bundleId: 'com.rbsoftware.bartne',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      navigationInfoParameters:
          new NavigationInfoParameters(forcedRedirectEnabled: true),
      itunesConnectAnalyticsParameters: new ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      dynamicLinkParametersOptions: new DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      try {
        final ShortDynamicLink shortLink = await parameters.buildShortLink();
        url = shortLink.shortUrl;
      } catch (e) {
        print('Erro:' + e.toString());
        url = await parameters.buildUrl();
      }
    } else {
      url = await parameters.buildUrl();
    }

    _linkMessage = url.toString();
    _isCreatingLink = false;
    d.dlink = _linkMessage;
    //print('Entrou aqui' + d.toString());
    FirebaseProvider().atualizar('protocolos', d.toJson(), d.id.toString());
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text('Protocolo Criado com sucesso!'),
      action: SnackBarAction(
          label: 'Compartilhar',
          onPressed: () {
            Share.share(d.titulo + ' ' + d.dlink);
          }),
    );
    _scafoldKey.currentState.showSnackBar(snackBar);
    Future.delayed(Duration(seconds: 2)).then((d) {
      if (_scafoldKey != null) {
        if (_scafoldKey.currentContext != null) {
          Navigator.pop(_scafoldKey.currentContext);
        } else {
          FirebaseAnalytics().logEvent(name: 'Null Context Cadastrar');
        }
      } else {
        FirebaseAnalytics().logEvent(name: 'Null Scaffold Key Cadastrar');
      }
      //Navigator.popAndPushNamed(_scafoldKey.currentState.context, '/Main');
    });
  }*/

  void refreshPictures() {
    images = new List<Foto>();

    getApplicationDocumentsDirectory().then((extDir) async {
      final String dirPath = '${extDir.path}/Aproxima/Fotos/';

      Directory directory = Directory(dirPath);
      var dirlist = directory.list();
      await for (FileSystemEntity f in dirlist) {
        if (f is File) {
          print('Found file ${f.path}');
          Foto foto =
              new Foto(0, f.path, Helpers.user.id, 0, '', DateTime.now());
          foto.isSelected = false;
          images.add(foto);
        } else if (f is Directory) {
          print('Found dir ${f.path}');
        }
      }
      images = images.reversed.toList();
      inFotos.add(images);
    }).catchError((err) {
      print('ERrro: ${err.tostring()}');
    });
  }
}
