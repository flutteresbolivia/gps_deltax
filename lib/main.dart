import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_1_22_6/pages/request_permission_page.dart';
import 'package:google_maps_1_22_6/pages/splash_page.dart';
import 'package:google_maps_1_22_6/providers/local_notifications_providers.dart';
import 'package:google_maps_1_22_6/providers/push_notifications_providers.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
 
  @override
  void initState() {
    super.initState();
  

    final pushProvider = new PushNotificationsProvider();
    pushProvider.initNotifications();

    pushProvider.mensajesStream.listen((data) {
      print('argumento desde main: $data');
      // _localNotificationsProviders.showLocalNotification(0, data: 'data',title: 'dasd');
 
      // localNotificationsProviders.showNotification(1990,
      //     'Hola  Te queremos informar que te encuentras atrasado con  para llegar al punto de carguío, hora estimada de llegada',
      //     data: data);
      // Navigator.pushNamed(context, 'mensaje');
      // navigatorKey.currentState.pushNamed('mensaje', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
      routes: {
        HomePage.routeName: (_) => HomePage(),
        RequestPermissionPage.routeName: (_) => RequestPermissionPage(),
      },
      
    );
  }
}
