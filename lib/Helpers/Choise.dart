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

const List<Choice> StatusChoises = const <Choice>[
  const Choice(title: 'Enviado', icon: Icons.place, color: Colors.yellow),
  const Choice(title: 'Encaminhado', icon: Icons.place, color: Colors.orange),
  const Choice(title: 'Em Andamento', icon: Icons.place, color: Colors.cyan),
  const Choice(title: 'Concluido', icon: Icons.place, color: Colors.green),
  const Choice(title: 'Excluido', icon: Icons.place, color: Colors.red),
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
          Icon(choice.icon, color: textStyle.color),
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
