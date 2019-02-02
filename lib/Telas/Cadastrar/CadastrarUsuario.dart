import 'package:aproxima/Telas/Cadastrar/CadastrarUsuarioController.dart';
import 'package:aproxima/Telas/Cadastrar/CadastrarUsuarioWidget.dart';
import 'package:aproxima/Telas/Login/LoginController.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class CadastrarUsuario extends StatefulWidget {
  LoginController lc;

  CadastrarUsuario(this.lc);

  _CadastrarUsuarioState createState() => _CadastrarUsuarioState();
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {
  CadastrarUsuarioController cuc;

  @override
  Widget build(BuildContext context) {
    cuc = CadastrarUsuarioController();
    return new BlocProvider<CadastrarUsuarioController>(
      child: CadastrarUsuarioWidget(widget.lc),
      bloc: cuc,
    );
  }
}
