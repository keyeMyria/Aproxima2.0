import 'package:aproxima/Telas/Mapa/Mapa.dart';
import 'package:flutter/material.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        const DrawerHeader(
          child: const Center(
            child: const Text("Flutter Map Examples"),
          ),
        ),
        new ListTile(
          title: const Text('OnTap'),
          selected: currentRoute == Mapa.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Mapa.route);
          },
        ),
      ],
    ),
  );
}
