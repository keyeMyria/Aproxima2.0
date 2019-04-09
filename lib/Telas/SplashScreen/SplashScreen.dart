import 'dart:async';

import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Telas/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;
  bool hasStarted = false;

  bool forward;
  double height;
  double width;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: const Duration(seconds: 5));
    /*.addAnimatable(
            animatable: new Tween<double>(begin: 300.0, end: 100.0),
            from: const Duration(milliseconds: 3000),
            to: const Duration(milliseconds: 3700),
            tag: "width",
            curve: Curves.decelerate)*/

    Timer(
        Duration(seconds: 6),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
  }

  Future<Null> _playAnimation() async {
    try {
      await controller.forward().orCancel;
      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  startSequence() {
    height = MediaQuery.of(context).size.height;

    width = MediaQuery.of(context).size.width;
    double finalPosition = (height / 2) - 285;

    /*.addAnimatable(
            animatable:
                new Tween<double>(begin: height / 2, end: (height / 2) - 50),
            from: const Duration(seconds: 1500),
            to: const Duration(milliseconds: 1700),
            tag: "Top",
            curve: Curves.easeIn)
        .addAnimatable(
            animatable:
                new Tween<double>(begin: (height / 2) - 50, end: height / 2),
            from: const Duration(seconds: 1700),
            to: const Duration(milliseconds: 2000),
            tag: "Top",
            curve: Curves.easeIn)*/
    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            animatable: new Tween<double>(begin: -800.0, end: finalPosition),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 1500),
            tag: "Top",
            curve: Curves.linear)

        //UP ANIMATION
        .addAnimatable(
            animatable: new Tween<double>(begin: finalPosition, end: -180.0),
            from: Duration(milliseconds: 1500),
            to: Duration(milliseconds: 1900),
            tag: "Top",
            curve: Curves.linear)
        .addAnimatable(
            animatable: new Tween<double>(begin: -180.0, end: finalPosition),
            from: Duration(milliseconds: 1900),
            to: Duration(milliseconds: 2300),
            tag: "Top",
            curve: Curves.linear)

        //UP ANIMATION
        .addAnimatable(
            animatable: new Tween<double>(begin: finalPosition, end: -90.0),
            from: Duration(milliseconds: 2300),
            to: Duration(milliseconds: 2700),
            tag: "Top",
            curve: Curves.linear)
        .addAnimatable(
            animatable: new Tween<double>(begin: -90.0, end: finalPosition),
            from: Duration(milliseconds: 2700),
            to: Duration(milliseconds: 3100),
            tag: "Top",
            curve: Curves.linear)

        //UP ANIMATION
        .addAnimatable(
            animatable: new Tween<double>(begin: finalPosition, end: -45.0),
            from: Duration(milliseconds: 3100),
            to: Duration(milliseconds: 3400),
            tag: "Top",
            curve: Curves.linear)
        .addAnimatable(
            animatable: new Tween<double>(begin: -45.0, end: finalPosition),
            from: Duration(milliseconds: 3400),
            to: Duration(milliseconds: 3800),
            tag: "Top",
            curve: Curves.linear)
        //UP ANIMATION
        .addAnimatable(
            animatable: new Tween<double>(begin: finalPosition, end: -20.0),
            from: Duration(milliseconds: 3800),
            to: Duration(milliseconds: 4200),
            tag: "Top",
            curve: Curves.linear)
        .addAnimatable(
            animatable: new Tween<double>(begin: -20.0, end: finalPosition),
            from: Duration(milliseconds: 4200),
            to: Duration(milliseconds: 4500),
            tag: "Top",
            curve: Curves.linear)
        .animate(controller);
    controller.forward();
    hasStarted = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!hasStarted) {
      startSequence();
    }
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: <Widget>[
            Image(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitHeight,
              image: AssetImage('assets/map_splash.jpg'),
            ),
            new AnimatedBuilder(
                builder: (context, child) {
                  return new Positioned(
                    top: sequenceAnimation["Top"].value,
                    left: (MediaQuery.of(context).size.width / 2) - 150,
                    child: Container(
                      width: 300,
                      height: 400,
                      child: Column(children: <Widget>[
                        child,
                      ]),
                    ),
                  );
                },
                animation: controller,
                child: Stack(children: <Widget>[
                  Image(
                    width: 300,
                    height: 400,
                    image: AssetImage('assets/logo.png'),
                  ),
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: Center(
                    child: Text.rich(TextSpan(
                        children: [
                      TextSpan(
                          text: 'proxim',
                          style: TextStyle(
                              color: Helpers.blue_default,
                              fontSize:
                                  MediaQuery.of(context).size.width * .15)),
                      TextSpan(
                          text: 'A',
                          style: TextStyle(
                              color: Helpers.blue_default,
                              fontSize:
                                  MediaQuery.of(context).size.width * .15)),
                      TextSpan(
                          text: '+',
                          style: TextStyle(
                              color: Helpers.green_default,
                              fontSize: MediaQuery.of(context).size.width * .2))
                    ],
                        text: ' A',
                        style: TextStyle(
                            color: Helpers.blue_default,
                            fontSize:
                                MediaQuery.of(context).size.width * .15)))))
          ])),
    );
  }
}
