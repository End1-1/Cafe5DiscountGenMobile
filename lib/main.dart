import 'package:cafe5_discount_gen_mobile/client_socket.dart';
import 'package:cafe5_discount_gen_mobile/config.dart';
import 'package:cafe5_discount_gen_mobile/widget_choose_settings.dart';
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
      title: 'Cafe5MobileClient',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const WidgetChooseSettings(),
    );
  }
}
