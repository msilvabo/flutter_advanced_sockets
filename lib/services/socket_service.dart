import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService extends ChangeNotifier {
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    print('_initConfig');
    IO.Socket socket = IO.io('http://10.241.2.214:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    socket.onConnect((_) {
      print('connect');
    });
    socket.onDisconnect((_) => print('disconnect'));
  }
}
