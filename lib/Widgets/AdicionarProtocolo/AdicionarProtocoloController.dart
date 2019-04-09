import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Foto.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Tag.dart';
import 'package:aproxima/Objetos/Tagss.dart';
import 'package:aproxima/Widgets/Tags/TagsController.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AdicionarProtocoloController implements BlocBase {
  bool _isCreatingLink = false;
  Protocolo protocolo;
  String _linkMessage;
  static Protocolo p;
  BehaviorSubject<Protocolo> _controllerProtocolo =
      new BehaviorSubject<Protocolo>();
  BehaviorSubject<LatLng> _controllerLocation = new BehaviorSubject<LatLng>();
  Stream<LatLng> get outLocation => _controllerLocation.stream;
  Sink<LatLng> get inLocation => _controllerLocation.sink;
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

  double zoom = 17;
  BehaviorSubject<double> _controllerZoom = new BehaviorSubject<double>();
  Stream<double> get outZoom => _controllerZoom.stream;
  Sink<double> get inZoom => _controllerZoom.sink;

  BehaviorSubject<String> _controllerLoading = new BehaviorSubject<String>();
  Stream<String> get outLoading => _controllerLoading.stream;
  Sink<String> get inLoading => _controllerLoading.sink;

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
    _controllerLocation.close();
    _controllerZoom.close();
    _controllerLoading.close();
  }

  AdicionarProtocoloController() {
    /*if (imagensGaleria == null) {
      imagensGaleria = new List<Asset>();
    }*/

    Location().onLocationChanged().listen((data) {
      print('PEGOU LOCATION FDP ${data.toString()}');
      inLocation.add(new LatLng(data.latitude, data.longitude));
    });
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

  void AddPicture(String s) {
    Foto foto = new Foto(0, s, Helpers.user.id, 0, '', DateTime.now());
    foto.isSelected = false;
    images.add(foto);
    images = images.reversed.toList();
    inFotos.add(images);
  }

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

  Future CadastrarProtocolo(String descricao, String titulo) {
    List<Foto> f = new List();
    return outFotos.first.then((fotos) {
      inLoading.add(' Verificando Fotos');
      if (fotos != null) {
        for (Foto ff in fotos) {
          if (ff.isSelected) {
            f.add(ff);
          }
        }
      } else {
        return 0;
      }
      if (tc.SelectedTag != null) {
        return outLocation.first.then((latlng) async {
          inLoading.add(' Adicionando Assuntos');
          if (latlng != null) {
            /*
            params.put("lat",p.getLat());
            params.put("lng",p.getLng());
            params.put("titulo",p.getTitulo());
            params.put("descricao",p.getDescricao());
            params.put("id_status",p.getId_status());
            params.put("user_id",p.getUser_id());
            params.put("cidade_id",p.getCidade_id());
            params.put("secretaria_id",p.getSecretaria_id());
            params.put("endereco",p.getEndereco());
            params.put("bairro",p.getBairro());
            params.put("permissao",p.getPermissao());
            params.put("Anonimo",p.getAnonimo());
            params.put("User_updatable",p.getUserUpdatable()+"");

            String id, String lat, String lng, String titulo, String descricao, String id_status,
             String user_id, String created_at, String updated_at,
             String deleted_at, String cidade_id, String secretaria_id, String endereco, String bairro, String permissao,String prioridade, Cidade cidade,User usuario, Status status, Secretaria secretaria,
            List<Tags> tags, List<Foto> fotos, List<UpdateProtocolo> updates_protocolos,String anonimo,int UserUpdatable
            */

            final coordinates = new Coordinates(1.10, 45.50);
            /* var addresses =
                await Geocoder.local.findAddressesFromCoordinates(coordinates);
            Address first = addresses.first;
            print("${first.featureName} : ${first.addressLine}");*/
            var body = {
              'lat': latlng.latitude.toString(),
              'lng': latlng.longitude.toString(),
              'titulo': titulo,
              'descricao': descricao,
              'id_status': '1',
              'user_id': Helpers.user.id.toString(),
              'cidade_id': Helpers.user.cidade.id_cidade.toString(),
              'secretaria_id': '',
              'endereco': '', //first.addressLine,
              'bairro': '',
              'permissao': '0',
              'Anonimo': '0',
              'User_updatable': '0',
            };
            print(
                'Body ${body} URL: http://www.aproximamais.net/webservice/json.php?cadastrarprotocolo=true&t=${DateTime.now().millisecondsSinceEpoch}');
            return http
                .post(
                    'http://www.aproximamais.net/webservice/json.php?cadastrarprotocolo=true&t=${DateTime.now().millisecondsSinceEpoch}',
                    body: body)
                .then((response) {
              inLoading.add(' Cadastrando Relato!');
              print('Protocolo RESPONSE ${response.body}');
              var j = json.decode(response.body);
              Protocolo p;
              for (var v in j) {
                //print(v.toString());
                p = new Protocolo.fromJson(v);
              }
              if (p != null) {
                print('Cadastrou Protocolo ${p.toString()}');
                /*params.put("idprotocolo",p.getId());
                params.put("idtags",jsonArray.toString());*/
                Tag t = tc.SelectedTag;
                List<String> tags = new List();
                tags.add(t.id.toString());
                var tagbody = {
                  'idprotocolo': p.id.toString(),
                  'idtags': jsonEncode(tags)
                };
                print(
                    'Body ${tagbody} URL: http://www.aproximamais.net/webservice/json.php?inserirtagprotcolo=true&t=${DateTime.now().millisecondsSinceEpoch}');
                return http
                    .post(
                        'http://www.aproximamais.net/webservice/json.php?inserirtagprotcolo=true&t=${DateTime.now().millisecondsSinceEpoch}',
                        body: tagbody)
                    .then((responseTag) async {
                  inLoading.add(' Validando Dados!');
                  print('TAG RESPONSE ${responseTag.body}');

                  Protocolo ppp;
                  for (var v in j) {
                    //print(v.toString());
                    ppp = new Protocolo.fromJson(v);
                  }
                  print('Protocolo Após Cadastrar Tag ${ppp.tags}');
                  if (p != null) {
                    print('Cadastrou Tags');

                    if (p.tags == null) {
                      p.tags = new List<Tagss>();
                    }
                    p.tags.add(new Tagss(t.id, p.id, t, 0));
                    var fotosArrayBody;
                    List fotosJson = new List();
                    for (Foto ff in f) {
                      var fileName = _randomString(20) + ".jpeg";
                      String base64Image =
                          base64Encode(File(ff.link).readAsBytesSync());
                      //fotosJson.add(jsonEncode(ff));
                      fotosJson.add(jsonEncode({
                        'img': base64Image,
                        'nome': fileName,
                        'texto': '',
                        'id_protocolo': p.id.toString(),
                        'id_user': Helpers.user.id.toString(),
                      }));
                    }
                    fotosArrayBody = {'fotos': json.encode(fotosJson)};
                    print('Fotos Body ${fotosArrayBody}');
                    print(
                        'URL URL: http://www.aproximamais.net/webservice/json.php?CadastrarFotos=true&t=${DateTime.now().millisecondsSinceEpoch}');
                    print('NUMITENS ${fotosJson.length}');
                    return http
                        .post(
                            'http://www.aproximamais.net/webservice/json.php?CadastrarFotos=true&t=${DateTime.now().millisecondsSinceEpoch}',
                            body: fotosArrayBody)
                        .then((responseFotos) async {
                      inLoading.add(' Adicionando Localização!');
                      print('FOTO RESPONSE ${responseFotos.body}');
                      Protocolo pp;
                      for (var v in j) {
                        //print(v.toString());
                        pp = new Protocolo.fromJson(v);
                      }
                      print('CADASTRADO COM SUCESSO TUDO ${pp.toString()}');
                      inLoading.add(' Notificando Funcionarios!');
                      if (pp != null) {
                        print(' UPDATES ${pp.updates_protocolos}');
                        print(' FOTOS ${pp.fotos}');
                        print(' TAGS ${pp.tags}');
                        print(' USUARIO ${pp.usuario}');
                        print(' ID ${pp.id}');

                        protocolo = await getProtocoloFromDL(pp.id.toString());
                        return 6;
                      } else {
                        return 5;
                      }
                    }).catchError((err) {
                      print('Erro ao Cadastrar Fotos : ${err.toString()}');
                    });
                    ;
                  } else {
                    return 4;
                  }
                }).catchError((err) {
                  print('Erro ao Cadastrar Tags : ${err.toString()}');
                });
              } else {
                return 3;
              }
            }).catchError((err) {
              print('Erro ao Cadastrar Protocolo : ${err.toString()}');
            });
          } else {
            return 2;
          }
        });
      } else {
        return 1;
      }
    }).catchError((err) {
      print('Erro na foto : ${err.toString()}');
    });
  }

  Future<Protocolo> getProtocoloFromDL(String id) {
    return http
        .get(
            'http://www.aproximamais.net/webservice/json.php?buscaprotocoloid=${id}')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
        //print(v.toString());
        Protocolo p = new Protocolo.fromJson(v);
        print('Protocolo from Dynamic ${p.toString()}');
        return p;
      }
    });
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });
    return String.fromCharCodes(codeUnits);
  }
}
