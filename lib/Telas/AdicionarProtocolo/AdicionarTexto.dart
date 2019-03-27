import 'package:flutter/material.dart';

class AdicionarTexto extends StatefulWidget {
  @override
  _AdicionarTextoState createState() => new _AdicionarTextoState();
}

class _AdicionarTextoState extends State<AdicionarTexto> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 5),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.blue[700],
                        style: BorderStyle.solid,
                        width: 0.3)),
                hintText: 'Burraco na via',
                labelText: 'Titulo',
                helperText: 'Defina o titulo',
                helperStyle: TextStyle(color: Colors.blue, fontSize: 16),
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 5),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.blue[700],
                        style: BorderStyle.solid,
                        width: 0.3)),
                hintText: 'Burraco na via',
                labelText: 'Descrição',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic)),
          ),
        ),
      ],
    );
  }
}
