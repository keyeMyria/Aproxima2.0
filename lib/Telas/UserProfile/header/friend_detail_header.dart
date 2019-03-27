import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Telas/UserProfile/UserRelatosController.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FriendDetailHeader extends StatelessWidget {
  FriendDetailHeader(
    this.friend,
    this.qtdeDesejos, {
    @required this.avatarTag,
  });

  final User friend;
  final Object avatarTag;
  final int qtdeDesejos;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
  }

  Widget _buildAvatar() {
    return CachedNetworkImage(
        fit: BoxFit.fill,
        width: 150,
        height: 150,
        placeholder: Image.asset(
          'assets/logo_sem_texto_teste.png',
          width: 150,
          height: 150,
        ),
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/aproximamais-b84ee.appspot.com/o/usuarios%2F${friend.id}.jpeg?alt=media&token=5cae4fd3-d3d4-44e4-893a-2349f6fda687');
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
            builder: (context, AsyncSnapshot<List<Protocolo>> snap) {
              return new Text(
                  'Relatos registrados: ${snap.hasData ? snap.data.length + 1 : '0'}',
                  style: followerStyle);
            },
            stream: urc.outUserRelatos,
          )
          /*,
          new Text(
            ' | ',
            style: followerStyle.copyWith(
                fontSize: 24.0, fontWeight: FontWeight.normal),
          ),
          new Text('100 Followers', style: followerStyle),*/
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        ],
      ),
    );
  }

  Widget _createPillButton(
    String text,
    BuildContext context, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        height: 60.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {
          // Navigator.of(context).pop();
        },
        child: new Text(text),
      ),
    );
  }

  UserRelatosController urc;
  @override
  Widget build(BuildContext context) {
    urc = BlocProvider.of<UserRelatosController>(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        new Column(
          children: <Widget>[
            _buildAvatar(),
            _buildFollowerInfo(textTheme),
            _buildActionButtons(theme, context),
          ],
        ),
      ],
    );
  }
}
