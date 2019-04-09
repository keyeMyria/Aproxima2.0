import 'package:aproxima/Helpers/Helpers.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon, this.color});

  final String title;
  final Widget icon;
  final Color color;
}

//TODO Buscar lista de departamentos por cidade

List<Choice> StatusChoises = <Choice>[
  Helpers.user.permissao >= 2
      ? Choice(
          title: 'Enviado',
          icon: Image(
              image: AssetImage('assets/marker_yellow.png'),
              height: 30,
              width: 20),
          color: Colors.yellowAccent)
      : {},
  Choice(
      title: 'Encaminhado',
      icon: Image(
          image: AssetImage('assets/marker_blue.png'), height: 30, width: 20),
      color: Colors.blue),
  Choice(
      title: 'Em Andamento',
      icon: Image(
          image: AssetImage('assets/marker_orange.png'), height: 30, width: 20),
      color: Colors.orange),
  Choice(
      title: 'Concluído',
      icon: Image(
        image: AssetImage('assets/marker_green.png'),
        height: 30,
        width: 20,
      ),
      color: Colors.greenAccent),
  Helpers.user.permissao >= 3
      ? Choice(
          title: 'Excluído',
          icon: Image(
              image: AssetImage('assets/marker_red.png'),
              height: 30,
              width: 20),
          color: Colors.red)
      : {},
  Choice(
    title: 'Todos',
    icon: Icon(
      Icons.all_inclusive,
      size: 25,
      color: Helpers.blue_default,
    ),
    color: Colors.blueAccent,
  ),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          choice.icon,
          Padding(
            padding: EdgeInsets.only(left: 5.0),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(choice.title,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ))),
        ],
      ),
    );
  }
}
