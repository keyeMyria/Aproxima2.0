import 'package:aproxima/Widgets/PaginaPrincipal/PaginaPrincipalPage.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(children: <Widget>[
        SvgDrawingWithCustomController("assets/cidade.svg"),
        new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModoListaPage(),
                ));
          },
          child: Icon(Icons.arrow_forward),
        )
      ]),
    ));
  }
}

class SvgDrawingWithCustomController extends StatefulWidget {
  SvgDrawingWithCustomController(this.assetName);

  final String assetName;
  @override
  SvgDrawingWithCustomControllerState createState() =>
      SvgDrawingWithCustomControllerState();
}

class SvgDrawingWithCustomControllerState
    extends State<SvgDrawingWithCustomController>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_running) {
      _controller.stop();
    } else {
      _controller.stop();
      _controller.repeat();
    }
    _running = !_running;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        decoration: new BoxDecoration(
          color: Colors.blue,
        ),
        child: GestureDetector(
          onTap: () {
            _controller.reset();
          },

          //AnimatedDrawing with a custom controller
          child: new RotatedBox(
              quarterTurns: 2,
              child: AnimatedDrawing.svg(
                this.widget.assetName,
                width: 100,
                height: 100,
                controller: this._controller,
                lineAnimation: LineAnimation.oneByOne,
                animationCurve: Curves.linear,
              )),
        ));
  }
}
