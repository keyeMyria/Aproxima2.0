import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Foto.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Widgets/AdicionarProtocolo/AdicionarProtocoloController.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
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

  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: this.page, keepPage: true);
  }

  @override
  void dispose() {
    controller.dispose();
    apc.dispose();
    super.dispose();
  }

  var page1;

  static const MethodChannel _channel =
      const MethodChannel('multi_image_picker');
  //CupertinoOptions options = const CupertinoOptions();

  PickImagens() {

    return Container();
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
        Padding(
          padding: const EdgeInsets.all(5.0),
          child:
              // _cameraTogglesRowWidget(),
              _thumbnailWidget(),
        ),
      ],
    );
    return StreamBuilder<int>(
        stream: apc.outPageController,
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
          if (snap.data != null) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              bottomNavigationBar: BottomAppBar(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                height: 40,
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.camera_alt),
                                        color: Colors.green,
                                        onPressed: () => takePicture(),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.photo_library),
                                        color: Colors.green,
                                        onPressed: () => PickImagens(),
                                      ),
                                    ])),
                            Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.green,
                              child: Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey[500],
                                loop: 9999,
                                child: IconButton(
                                  icon: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text('Avançar',
                                            style: TextStyle(fontSize: 26)),
                                        Icon(Icons.navigate_next),
                                      ]),
                                  color: Colors.white,
                                  iconSize: 35,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ]))),
              body: page1,
            );
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
                  itemCount: snap.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            snap.data[index].isSelected =
                                !snap.data[index].isSelected;
                            apc.inFotos.add(snap.data);
                          },
                          child: Container(
                            decoration: snap.data[index].isSelected
                                ? BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                        color: Colors.green,
                                        width: 2,
                                        style: BorderStyle.solid))
                                : null,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.file(File(snap.data[index].link)),
                                snap.data[index].isSelected
                                    ? Center(
                                        child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 60,
                                      ))
                                    : Container()
                              ],
                            ),
                          ),
                        ));
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (Helpers.cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in Helpers.cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller.value.isRecordingVideo
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

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
