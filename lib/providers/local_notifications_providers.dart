import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsProvider {
  static const String defaultChannelId = 'channel_id';
  static const String defaultChannelName = 'channel_name';
  static const String defaultChannelDescription = 'channel_description';
  static const String defaultTitle = 'DeltaX.la';

  String _channelId;
  String _channelName;
  String _channelDescription;

  final _methodChannel = MethodChannel("app.meedu/background-location");

  FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      new FlutterLocalNotificationsPlugin();
  NotificationDetails platformChannelSpecifics = new NotificationDetails();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

// final MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings();
// await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//     onSelectNotification: selectNotification);

  init() async {
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation("America/La_Paz"));
    final String timeZoneName =
        await _methodChannel.invokeMethod('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation('America/La_Paz'));
    print(timeZoneName);
    final androidNotificationChannel = AndroidNotificationChannel(
      this._channelId,
      this._channelName,
      this._channelDescription, //channel description
      importance: Importance.high,
    );
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      this._channelId,
      this._channelName,
      this._channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    this.platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: null);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationPlugin.initialize(initializationSettings);
    await flutterLocalNotificationPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
    // await flutterLocalNotificationPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "your channel",
      "channel name",
      "channel descrption",
      priority: Priority.max,
      importance: Importance.max,
    );
    // channel IOS
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: ,
      // macOS: ,
    );
    await this.flutterLocalNotificationPlugin.show(
          0,
          "this is a notification",
          "inside the notification",
          platformChannelSpecifics,
        );
  }
}
 