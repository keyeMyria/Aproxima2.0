import 'package:aproxima/Helpers/Helpers.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon, this.color});

  final String title;
  final IconData icon;
  final Color color;
}

//TODO Buscar lista de departamentos por cidade

const List<Choice> MenuPrincipal = const <Choice>[
  const Choice(title: 'Lista', icon: Icons.list),
  const Choice(title: 'Oficios Protocolados', icon: Icons.playlist_add_check),
  const Choice(title: 'Termos de Uso', icon: Icons.assignment),
  const Choice(title: 'Configurações', icon: Icons.settings),
  const Choice(title: 'Contato', icon: Icons.phone),
  const Choice(title: 'Ajuda', icon: Icons.help),
  const Choice(title: 'Sair', icon: Icons.exit_to_app),
];

List<Choice> StatusChoises = <Choice>[
  Helpers.user.permissao >= 2
      ? Choice(title: 'Enviado', icon: Icons.place, color: Colors.yellowAccent)
      : {},
  Helpers.user.permissao >= 3
      ? Choice(title: 'Excluído', icon: Icons.place, color: Colors.red)
      : {},
  Choice(title: 'Encaminhado', icon: Icons.place, color: Colors.orangeAccent),
  Choice(
      title: 'Em Andamento', icon: Icons.place, color: Colors.lightBlueAccent),
  Choice(title: 'Concluído', icon: Icons.place, color: Colors.greenAccent),
  Choice(title: 'Todos', icon: Icons.all_inclusive, color: Colors.blueAccent),
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
          Icon(choice.icon, color: choice.color),
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
