import 'package:cviewdiscount/client_socket.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/widget_choose_settings.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.init();
  Config.setString(key_server_username, "end1_1@mail.ru");
  Config.setString(key_server_password, "parole");
  Config.setString(key_database_name, "cafe5");
  Config.setInt(key_protocol_version, 1);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CView Discount',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const WidgetChooseSettings(),
    );
  }
}
