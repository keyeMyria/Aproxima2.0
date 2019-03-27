import 'package:aproxima/Widgets/AdicionarProtocolo/AdicionarProtocoloController.dart';
import 'package:aproxima/Widgets/AdicionarProtocolo/AdicionarProtocoloWidget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdicionarProtocoloPage extends StatefulWidget {
  _AdicionarProtocoloPageState createState() => _AdicionarProtocoloPageState();
}

class _AdicionarProtocoloPageState extends State<AdicionarProtocoloPage> {
  AdicionarProtocoloController apc;
  @override
  Widget build(BuildContext context) {
    apc = AdicionarProtocoloController();
    return BlocProvider(
      child: StreamBuilder(
          stream: apc.outProtocolo,
          builder: (context, snap) {
            return snap.hasData
                ? AdicionarProtocoloWidget(p: snap.data)
                : Center(
                    child: SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
          }),
      bloc: apc,
    );
  }
}
