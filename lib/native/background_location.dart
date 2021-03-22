import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_1_22_6/providers/local_notifications_providers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BackgroundLocation {
  BackgroundLocation._internal();
  static BackgroundLocation _instance = BackgroundLocation._internal();
  static BackgroundLocation get instance => _instance;

  final _methodChannel = MethodChannel("app.meedu/background-location");
  final _eventChannel = EventChannel("app.meedu/background-location-events");

  StreamController<LatLng> _controller = StreamController.broadcast();
  StreamSubscription _geolocatorSubs, _iosSubs;
  bool _running = false;

  Stream<LatLng> get stream => _controller.stream;

  Future<void> start() async {
    if (_running) throw new Exception('background location running');

    if (!Platform.isIOS) {
      _geolocatorSubs =  Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, distanceFilter: 50).listen(
        (Position position) {
          if (position != null) {
            // localNotificationsProviders.init();
            // localNotificationsProviders.showNotification(position.longitude);
            _controller.sink.add(
              LatLng(position.latitude, position.longitude),
            );
          }
        },
      );
    } else {
      _iosSubs = _eventChannel.receiveBroadcastStream().listen(
        (data) {
          print("😜 $data");
          final map = Map<String, dynamic>.from(data);
          final position = LatLng(map['lat'], map['lng']);
          _controller.sink.add(position);
        },
      );
    }
     _methodChannel.invokeMethod('start');

    _running = true;
  }

  Future<void> stop() async {
    if (Platform.isIOS) {
      await _iosSubs?.cancel();
    } else {
      await _geolocatorSubs?.cancel();
    }

    await _methodChannel.invokeMethod('stop');
    _controller.close();
    _running = false;
  }
}
