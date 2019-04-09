import 'dart:async';
import 'dart:io';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Telas/SplashScreen/SplashScreen.dart';
import 'package:aproxima/Widgets/AdicionarProtocolo/AdicionarProtocoloWidget.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'database',
    options: Platform.isIOS
        ? const FirebaseOptions(
            apiKey: 'AIzaSyCbXnPT3n-bTsDmTYPfNAk4zWCn88SlnF4',
            googleAppID: '1:29966875189:android:48a756ff5384df0d',
            gcmSenderID: '29966875189',
            databaseURL: 'https://aproximamais-b84ee.firebaseio.com',
          )
        : const FirebaseOptions(
            apiKey: 'AIzaSyCbXnPT3n-bTsDmTYPfNAk4zWCn88SlnF4',
            googleAppID: '1:29966875189:android:48a756ff5384df0d',
            gcmSenderID: '29966875189',
            databaseURL: 'https://aproximamais-b84ee.firebaseio.com',
          ),
  );
  try {
    Helpers.cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Helpers.blue_default));
    return new MaterialApp(
      color: Helpers.blue_default,
      theme: ThemeData(
          accentColor: Helpers.green_default,
          primaryColor: Helpers.blue_default),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
