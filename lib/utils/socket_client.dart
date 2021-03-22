import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'latlng_extension.dart';

class SocketClient {
  SocketClient._internal();

  static SocketClient _instance = SocketClient._internal();
  static SocketClient get instance => _instance;

  IO.Socket _socket;

  connect() {
    // this._socket = IO.io('http://192.168.1.18:5000', <String, dynamic>{
    //   'transports': ['websocket'],
    // });

    this._socket = IO.io(
        'https://deltaxbackendstaging.azurewebsites.net',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    this._socket.connect();
    this._socket.onConnect((_) {
      print('connect');
      this._socket.emit('msg', 'test');
    });
    this._socket.on('event', (data) => print(data));
    this._socket.onDisconnect((_) => print('disconnect'));
    this._socket.onError((_) => print('error'));
    this._socket.onConnectError((data) => print('connected error $data'));
    this._socket.on('fromServer', (_) => print(_));
    // this._socket.on('connect', (data) {
    //   print('🎃 connected');
    // });
    // this._socket.on('connect_error', (data) {
    //   print('🎃 connect_error $data');
    // });
    // this._socket.on('error', (data) {
    //   print('🎃 error $data');
    // });
    // this._socket.on('disconnect', (data) {
    //   print('🎃 disconnect $data');
    // });
  }

  sendLocation(LatLng location) {
    if (this._socket != null) {
      this._socket.emit(
            'tracking',
            location.format(),
          );
    }
  }

  disconnect() {
    if (this._socket != null) {
      this._socket.disconnect();
      this._socket = null;
    }
  }
}
