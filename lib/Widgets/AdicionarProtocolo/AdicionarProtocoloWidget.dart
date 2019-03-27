import 'dart:convert';
import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Foto.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Tag.dart';
import 'package:aproxima/Telas/Comentario/ComentarioPage.dart';
import 'package:aproxima/Widgets/AdicionarProtocolo/AdicionarProtocoloController.dart';
import 'package:aproxima/Widgets/Tags/TagsController.dart';
import 'package:aproxima/Widgets/Tags/TagsWidget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AdicionarProtocoloWidget extends StatefulWidget {
  Protocolo p;

  AdicionarProtocoloWidget({this.p});

  @override
  _AdicionarProtocoloWidgetState createState() =>
      new _AdicionarProtocoloWidgetState();
}

class _AdicionarProtocoloWidgetState extends State<AdicionarProtocoloWidget>
    with SingleTickerProviderStateMixin {
  AdicionarProtocoloController apc;
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool selected = false;
  PageController pageController;
  int page = 0;
  Color c = Colors.lightGreenAccent;
  Animation<double> animation;
  AnimationController animcontroller;
  TextEditingController DescricaoController = TextEditingController();

  TapGestureRecognizer _longPressRecognizer;
  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: this.page, keepPage: true);
    _longPressRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  void _handlePress() {
    HapticFeedback.vibrate();
    whatsAppOpen();
  }

  @override
  void dispose() {
    controller.dispose();
    apc.dispose();
    super.dispose();
  }

  var page1;
  var page2;
  var page3;
  var page4;

  PickImagens() async {
    ImagePicker.pickImage(source: ImageSource.gallery).then((f) {
      apc.AddPicture(f.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    apc = BlocProvider.of<AdicionarProtocoloController>(context);
    if (!selected) {
      onNewCameraSelected(Helpers.cameras[0]);
      selected = true;
    }
    page1 = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text.rich(
            TextSpan(
                text: 'Que tal tirar algumas fotos pra ajudar no seu Relato?',
                style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
                children: []),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: _cameraPreviewWidget(),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: controller != null && controller.value.isRecordingVideo
                    ? Colors.redAccent
                    : Colors.grey,
                width: 3.0,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: () => takePicture(),
          iconSize: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child:
              // _cameraTogglesRowWidget(),
              _thumbnailWidget(),
        ),
      ],
    );

    page3 = Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Text.rich(
          TextSpan(
            text:
                'Falta pouco!  \n\n Agorá vamos definir a localização do problema \n\n',
            style: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
            children: [],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text.rich(
          TextSpan(
              text:
                  'Quanto mais preciso a localização mais facil será resolver o problema \n\nVocê pode alterar a localização clicando no local desejado no Mapa.',
              style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
          textAlign: TextAlign.start,
        ),
      ),
      StreamBuilder(
          stream: apc.outLocation,
          builder: (context, AsyncSnapshot<LatLng> location) {
            if (location.hasData) {
              return StreamBuilder(
                stream: apc.outZoom,
                builder: (context, zoom) {
                  return GestureDetector(
                      onScaleUpdate: (details) {
                        apc.inZoom.add(details.scale);
                      },
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              height: 350,
                              width: MediaQuery.of(context).size.width * 9,
                              child: new FlutterMap(
                                options: new MapOptions(
                                  interactive: true,
                                  onTap: (ll) {
                                    apc.inLocation.add(ll);
                                  },
                                  center: location.data,
                                  zoom: zoom.hasData ? zoom.data : 17,
                                ),
                                mapController: MapController(),
                                layers: [
                                  new TileLayerOptions(
                                    urlTemplate:
                                        "https://api.tiles.mapbox.com/v4/"
                                        "{id}/{z}/{x}/{y}@2x.png?access_token=sk.eyJ1IjoicmJzb2Z0d2FyZSIsImEiOiJjam5xYng1aG8wMG55M3hreXJlZmVxMjA1In0.NBY7xfp9rERgMM3Ub1iwFg",
                                    additionalOptions: {
                                      'accessToken':
                                          'sk.eyJ1IjoicmJzb2Z0d2FyZSIsImEiOiJjam5xYng1aG8wMG55M3hreXJlZmVxMjA1In0.NBY7xfp9rERgMM3Ub1iwFg',
                                      'id': 'mapbox.streets',
                                    },
                                  ),
                                  new MarkerLayerOptions(markers: [
                                    Marker(
                                        point: location.data,
                                        builder: (context) {
                                          return Icon(
                                            Icons.place,
                                            color: Colors.blue,
                                            size: 35,
                                          );
                                        })
                                  ]),
                                ],
                              ))));
                },
              );
            } else {
              return new Container();
            }
          })
    ]);
    page2 = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text.rich(
                TextSpan(
                    text: 'Agora escolha o assunto relacionado ao seu Relato',
                    style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                    children: []),
                textAlign: TextAlign.center,
              ),
            ),
            TagsWidget()
          ],
        ));

    page4 = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Text.rich(
              TextSpan(
                text: 'Uma Ultima coisa!  \n\n Descreva o seu problema \n\n',
                style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
                children: [],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text.rich(
              TextSpan(
                  text:
                      'Quanto mais mais detalhes você fornecer mais facil será pra resolver o problema \n\nApós descrever o seu problema basta clicar em enviar e as pessoas saberão desse problema!',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal)),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: TextField(
                controller: DescricaoController,
                maxLines: 13,
                autocorrect: true,
                enabled: true,
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey[400],
                            width: 4,
                            style: BorderStyle.solid)),
                    hintText: 'Buraco no meio da rua',
                    labelText: 'Descrição',
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    )),
              ))
        ],
      ),
    );
    return StreamBuilder<int>(
        stream: apc.outPageController,
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
          if (snap.data != null) {
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        if (pageController.page == 0) {
                          Navigator.of(context).pop();
                        } else {
                          onPageChanged((pageController.page - 1).toInt());
                        }
                      }),
                  title: Text(
                    'Relatar um Problema',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                resizeToAvoidBottomPadding: true,
                bottomNavigationBar: BottomAppBar(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[500],
                      loop: 9999,
                      child: IconButton(
                          icon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(snap.data != 3 ? 'Avançar' : 'Concluir',
                                    style: TextStyle(fontSize: 26)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                snap.data != 3
                                    ? Icon(Icons.navigate_next)
                                    : Icon(Icons.send),
                              ]),
                          color: Colors.white,
                          iconSize: 35,
                          onPressed: () {
                            if (snap.data != 3) {
                              openNextState();
                            } else {
                              if (DescricaoController.text != null ||
                                  DescricaoController.text != '') {
                                apc.CadastrarProtocolo(DescricaoController.text)
                                    .then((resultado) {
                                  print('Resultado : ${resultado}');
                                  switch (resultado) {
                                    case 0:
                                      //TODO SEM FOTOS
                                      break;
                                    case 1:
                                      //TODO SEM TAG
                                      break;
                                    case 2:
                                      //TODO SEM LOCALIZAÇÂO
                                      break;
                                    case 3:
                                      //TODO ERRO AO CADASTRAR PROTOCOLO;
                                      break;
                                    case 4:
                                      //TODO ERRO AO CADASTRAR TAG;
                                      break;
                                    case 5:

                                      //TODO ERRO AO CADASTRAR FOTOS
                                      break;
                                    case 6:
                                      //TODO TUDO CERTO;
                                      Navigator.of(context).pop();
                                      Helpers.nh.sendNotification({
                                        'title':
                                            '${Helpers.user.nome} Fez um Relato ${apc.protocolo.titulo}',
                                        'responsavel':
                                            json.encode(Helpers.user),
                                        'tipo': 0.toString(),
                                        'sujeito': apc.protocolo.id.toString(),
                                        'topic':
                                            '${Helpers.user.cidade.cidade}',
                                        'foto': Helpers.user.foto == null
                                            ? 'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'
                                            : Helpers.user.foto,
                                        'data': DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                      });
                                      print('Protocolo AQUI ${apc.protocolo}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ComentarioPage(
                                                      apc.protocolo)));
                                  }
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                          shape: Border.all(),
                                          title: new Text(
                                            'Nenhuma Descrição',
                                          ),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors.blue[900]),
                                              ),
                                            ),
                                          ],
                                          content: Container(
                                              child: Text.rich(TextSpan(
                                            text:
                                                'Você não descreveu o problema, quanto mais informações mais facil será resolvermos este problema!  ',
                                          ))));
                                    });
                              }
                            }
                          }),
                    ),
                  ),
                ),
                body: PageView(
                  children: <Widget>[page1, page2, page3, page4],
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: onPageChanged,
                ));
          } else {
            return Container();
          }
        });
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  void onTap(int index) {
    apc.inPageController.add(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
    apc.inPageController.add(page);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Container(
      height: 128,
      width: MediaQuery.of(context).size.width * 6,
      child: StreamBuilder(
          stream: apc.outFotos,
          builder: (context, AsyncSnapshot<List<Foto>> snap) {
            if (snap.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snap.data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue)),
                              child: Center(
                                  child: IconButton(
                                icon: const Icon(Icons.photo_library),
                                color: Colors.blue,
                                onPressed: () => PickImagens(),
                                iconSize: 30,
                              ))));
                    } else {
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              snap.data[index - 1].isSelected =
                                  !snap.data[index - 1].isSelected;
                              apc.inFotos.add(snap.data);
                            },
                            child: Container(
                              decoration: snap.data[index - 1].isSelected
                                  ? BoxDecoration(
                                      color: Colors.blue,
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                          style: BorderStyle.solid))
                                  : null,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Image.file(File(snap.data[index - 1].link)),
                                  snap.data[index - 1].isSelected
                                      ? Center(
                                          child: Icon(
                                          Icons.check,
                                          color: Colors.blue,
                                          size: 60,
                                        ))
                                      : Container(),
                                ],
                              ),
                            ),
                          ));
                    }
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Aproxima/Fotos/';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    apc.refreshPictures();
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void whatsAppOpen() async {
    //print('ENTROU AQUI');
    var whatsappUrl =
        "whatsapp://send?phone=5542999319375&text=Ola, Gostaria de Conversar sobre o Aplicativo AproximaMais,";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  openNextState() {
    print('AQUI PAGINA ${pageController.page.toString()}');
    if (pageController.page == 0) {
      List<Foto> f = new List();
      apc.outFotos.first.then((fotos) {
        if (fotos != null) {
          for (Foto ff in fotos) {
            if (ff.isSelected) {
              f.add(ff);
            }
          }

          if (f.length != 0) {
            onPageChanged(1);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      shape: Border.all(),
                      title: new Text(
                        'Nenhuma foto Selecionada',
                      ),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Voltar',
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            onPageChanged(1);
                            Navigator.of(context).pop();
                            print('CLICOU FDP');
                          },
                          child: Text(
                            'Continuar',
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        )
                      ],
                      content: Container(
                          child: Text.rich(TextSpan(
                              text:
                                  'Você não selecionou nenhuma foto, deseja prosseguir mesmo assim?',
                              children: [
                            TextSpan(
                                text:
                                    'Clique nas fotos na parte inferior para seleciona-las',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic)),
                            TextSpan(
                                text:
                                    'Não achou o assunto relacionado ao problema? Clique AQUI',
                                recognizer: _longPressRecognizer,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic))
                          ]))));
                });
          }
        }
      });
    } else if (pageController.page == 1) {
      print('ENTROU PAGINA 1');
      //TODO LOGICA CHECANDO A TAG

      Tag t = tc.SelectedTag;
      print('ENTROU THEN');
      if (t != null) {
        onPageChanged(2);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                  shape: Border.all(),
                  title: new Text(
                    'Nenhum Assunto Selecionado',
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Voltar',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        onPageChanged(2);
                        Navigator.of(context).pop();
                        print('CLICOU FDP');
                      },
                      child: Text(
                        'Continuar',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    )
                  ],
                  content: Container(
                      child: Text.rich(TextSpan(
                          text:
                              'Você não selecionou nenhum asssunto, deseja prosseguir mesmo assim?  ',
                          children: [
                        TextSpan(
                            text:
                                'Clique no assunto relacionado para seleciona-lo.\n\n\n\n',
                            style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic)),
                        TextSpan(
                            text: 'Não Achou o assunto que procura?',
                            children: [
                              TextSpan(
                                  text: 'Clique AQUI',
                                  recognizer: _longPressRecognizer,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic)),
                            ],
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic))
                      ]))));
            });
      }
    } else if (pageController.page == 2) {
      onPageChanged(3);
    }
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
