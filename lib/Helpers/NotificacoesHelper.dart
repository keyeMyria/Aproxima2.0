import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aproxima/Helpers/BadgerController.dart';
import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/News.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/User.dart';
import 'package:aproxima/Widgets/News/NewsController.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacoesHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String iconPath = 'logo_branca';
  String largeIconPath = 'logo_preta';

  static News news;
  sendNotification(Map<String, dynamic> body) {
    print('Enviando Push');
    String url =
        'https://us-central1-aproximamais-b84ee.cloudfunctions.net/helloWorld';
    http.post(url, body: body).then((v) {
      print('BODY DA NOTIFICAÇÃO ${v.body}');
    }).catchError((e) {
      print('Err:' + e.toString());
    });
  }

  final _random = new Random();

  Future showNotification(Map<String, dynamic> msg, context) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      icon: iconPath,
      largeIcon: largeIconPath,
      playSound: true,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print('AQUI MSG FDP ${msg.toString()}');

    String title = msg['data']['title'];

    title = title.length > 55 ? title.substring(0, 54) + '...' : title;
    print(title.length);

    SharedPreferences.getInstance().then((sp) async {
      if (Helpers.user == null) {
        Helpers.user = User.fromJson(json.decode(sp.getString('User')));
      }
      News n = new News(
          Helpers.user.id.toString(),
          msg['data']['title'],
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(msg['data']['data'].toString())),
          0,
          User.fromJson(json.decode(msg['data']['responsavel'])),
          msg['data']['sujeito']);
      await flutterLocalNotificationsPlugin.show(
          0,
          title,
          Helpers().readTimestamp(DateTime.fromMillisecondsSinceEpoch(
              int.parse(msg['data']['data'].toString()))),
          platformChannelSpecifics,
          payload: '');

      news = n;
      saveNotification(n);
      print('CHAMANDO ADD BADGE');
      bc.addBadge();
    });
  }

  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
/*new News(Helpers.user.id.toString(), 'Teste Noticia',
                DateTime.now(), 0, Helpers.user*/

  Future saveNotification(News n) async {
    print('Iniciou User NOTIFICATION');
    NewsController nc = new NewsController();
    nc.increment(n);
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future scheduleNotification() async {
    //11:30 a 12:40, 18:30 as 17:30

    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 5));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'secondary_icon',
        sound: 'slow_spring_board',
        largeIcon: 'sample_large_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        color: const Color.fromARGB(255, 255, 0, 0));
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future showNotificationWithNoSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'silent channel id',
        'silent channel name',
        'silent channel description',
        playSound: false,
        styleInformation: new DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, '<b>silent</b> title',
        '<b>silent</b> body', platformChannelSpecifics);
  }

  Future showBigPictureNotification() async {
    var directory = await getApplicationDocumentsDirectory();
    var largeIconResponse = await http.get('http://via.placeholder.com/48x48');
    var largeIconPath = '${directory.path}/largeIcon';
    var file = new File(largeIconPath);
    await file.writeAsBytes(largeIconResponse.bodyBytes);

    var bigPicturePath = '${directory.path}/bigPicture';
    file = new File(bigPicturePath);

    var bigPictureStyleInformation = new BigPictureStyleInformation(
        bigPicturePath, BitmapSource.FilePath,
        largeIcon: largeIconPath,
        largeIconBitmapSource: BitmapSource.FilePath,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigPicture,
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future showBigPictureNotificationHideExpandedLargeIcon(
      Map<String, dynamic> msg) async {
    var directory = await getApplicationDocumentsDirectory();
    var largeIconResponse = await http.get('http://via.placeholder.com/48x48');
    print('PATH :: >> ${directory.path}');
    Directory d = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "app.txt");
    ByteData data = await rootBundle.load("assets/logo.png");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    var file = await File(dbPath).writeAsBytes(bytes);
    await file.writeAsBytes(largeIconResponse.bodyBytes);
    var bigPictureResponse =
        await http.get('http://via.placeholder.com/400x800');
    var bigPicturePath = '${directory.path}/bigPicture';
    file = new File(bigPicturePath);
    await file.writeAsBytes(bigPictureResponse.bodyBytes);
    print(msg['data']['data'].toString());
    var bigPictureStyleInformation = new BigPictureStyleInformation(
        bigPicturePath, BitmapSource.FilePath,
        contentTitle: msg['title'],
        htmlFormatContentTitle: true,
        summaryText: Helpers().readTimestamp(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(msg['data']['data'].toString()))),
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        largeIcon: file.path,
        largeIconBitmapSource: BitmapSource.FilePath,
        style: AndroidNotificationStyle.BigPicture,
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);

    if (Helpers.user == null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      print(sp.get('User'));
      Helpers.user = new User.fromJson(json.decode(sp.getString('User')));
      print(Helpers.user);
    }
    SharedPreferences.getInstance().then((sp) async {
      if (Helpers.user == null) {
        Helpers.user = User.fromJson(json.decode(sp.getString('User')));
      }
      News n = new News(
          Helpers.user.id.toString(),
          msg['title'],
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(msg['data']['data'].toString())),
          0,
          User.fromJson(json.decode(msg['responsavel'])),
          msg['data']['sujeito']);
      print('CHAMANDO ADD BADGE');
      bc.addBadge();
    });
    // addBadge();
  }

  Future showBigTextNotification() async {
    var bigTextStyleInformation = new BigTextStyleInformation(
        'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        htmlFormatBigText: true,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);

    //TODO ARRUMAR A NEWS DE ACORDO COM A DATA;
  }

  Future showInboxNotification() async {
    var lines = new List<String>();
    lines.add('line <b>1</b>');
    lines.add('line <i>2</i>');
    var inboxStyleInformation = new InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name', 'inbox channel description',
        style: AndroidNotificationStyle.Inbox,
        styleInformation: inboxStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future showGroupedNotifications() async {
    var groupKey = 'com.android.example.WORK_EMAIL';
    var groupChannelId = 'grouped channel id';
    var groupChannelName = 'grouped channel name';
    var groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    var firstNotificationAndroidSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.Max,
        priority: Priority.High,
        groupKey: groupKey);
    var firstNotificationPlatformSpecifics =
        new NotificationDetails(firstNotificationAndroidSpecifics, null);
    await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    var secondNotificationAndroidSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.Max,
        priority: Priority.High,
        groupKey: groupKey);
    var secondNotificationPlatformSpecifics =
        new NotificationDetails(secondNotificationAndroidSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // create the summary notification required for older devices that pre-date Android 7.0 (API level 24)
    var lines = new List<String>();
    lines.add('Alex Faarborg  Check this out');
    lines.add('Jeff Chang    Launch Party');
    var inboxStyleInformation = new InboxStyleInformation(lines,
        contentTitle: '2 new messages', summaryText: 'janedoe@example.com');
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        style: AndroidNotificationStyle.Inbox,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two new messages', platformChannelSpecifics);
  }

  Future cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onSelectNotification(String n) async {
    //print('Entrou AQUI');
  }

  Future showOngoingNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
        'ongoing notification body', platformChannelSpecifics);
  }

  Future repeatNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      'repeating description',
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  Future showDailyAtTime() async {
    SharedPreferences.getInstance().then((sp) async {
    if(!sp.getBool('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}')) {
      var horarios = [
        Time(next(11, 12), next(0, 30)),
        Time(next(18, 19), next(0, 60))
      ];

      var time = horarios[next(0, 1)];
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
        icon: iconPath,
        largeIcon: largeIconPath,
      );
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      News n = new News('0', '', DateTime.now(), 4, Helpers.aproximaUser, '');
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          'Reporte um problema',
          'Encontrou algum problema hoje?',
          time,
          platformChannelSpecifics,
          payload: '');
      print('Saiu AQUI AQUI');
      sp.setBool('${DateTime
          .now()
          .day}/${DateTime
          .now()
          .month}/${DateTime
          .now()
          .year}', true);
    }
    });
  }

  Future showWeeklyAtDayAndTime() async {
    var time = new Time(10, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on Monday at approximately ${toTwoDigitString(time.hour)}:${toTwoDigitString(time.minute)}:${toTwoDigitString(time.second)}',
        Day.Monday,
        time,
        platformChannelSpecifics);
  }

  Future showNotificationWithNoBadge() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'no badge channel', 'no badge name', 'no badge description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'no badge title', 'no badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future showProgressNotification() async {
    var maxProgress = 5;
    for (var i = 0; i <= maxProgress; i++) {
      await Future.delayed(Duration(seconds: 1), () async {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            'progress channel description',
            channelShowBadge: false,
            importance: Importance.Max,
            priority: Priority.High,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future showIndeterminateProgressNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'indeterminate progress channel',
        'indeterminate progress channel',
        'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'indeterminate progress notification title',
        'indeterminate progress notification body',
        platformChannelSpecifics,
        payload: 'item x');
  }

  String toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload, context) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text('Ok'),
                onPressed: () {},
              )
            ],
          ),
    );
  }

  Future getDL(Protocolo post, bool short) async {
    final DynamicLinkParameters parameters = new DynamicLinkParameters(
      domain: 'aproxima.page.link',
      link:
          Uri.parse('http://www.aproximamais.net/relato/' + post.id.toString()),
      androidParameters: new AndroidParameters(
        packageName: 'com.brunoeleodoro.org.aproxima',
        minimumVersion: 0,
      ),
      iosParameters: new IosParameters(
        bundleId: 'com.brunoeleodoro.org.aproxima',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      navigationInfoParameters:
          new NavigationInfoParameters(forcedRedirectEnabled: true),
      dynamicLinkParametersOptions: new DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      try {
        final ShortDynamicLink shortLink = await parameters.buildShortLink();
        url = shortLink.shortUrl;
        print(url);
      } catch (e) {
        print('Erro:' + e.toString());
        url = await parameters.buildUrl();
      }
    } else {
      url = await parameters.buildUrl();
    }
    print(url);

    var _linkMessage = url.toString();
    post.dlink = _linkMessage;
    //print('Entrou aqui' + d.toString());
    print('CHEGOU AQUI');
    return _linkMessage;
  }
}
