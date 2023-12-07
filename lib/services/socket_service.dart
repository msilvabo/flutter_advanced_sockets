import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  IO.Socket _socket = IO.io('..');

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    print('_initConfig');
    _socket = IO.io('https://e5be-181-115-151-130.ngrok-free.app/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.on('connect', (_) {
      print('connect from flutter');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      print('disconnect from flutter');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    _socket.on('nuevo-mensaje', (payload) {
      print('Nuevo-mensaje: ');
      print('nombre: ' + payload['nombre']);
      print('mensaje: ' + payload['mensaje']);
      print(payload.containsKey('mensaje2')
          ? 'mensaje2: ' + payload['mensaje2']
          : 'no hay datos...');

      //);
    });
  }
}
