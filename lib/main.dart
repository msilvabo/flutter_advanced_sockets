import 'package:flutter/material.dart';
import 'package:flutter_expert_socket/services/socket_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_expert_socket/pages/home.dart';
import 'package:flutter_expert_socket/pages/status.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => SocketService())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home':(_) => HomePage(),
          'status':(_) => StatusPage()
        },
      ),
    );
  }
}

