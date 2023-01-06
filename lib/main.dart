import 'package:cafe5_discount_gen_mobile/client_socket.dart';
import 'package:cafe5_discount_gen_mobile/config.dart';
import 'package:cafe5_discount_gen_mobile/db.dart';
import 'package:cafe5_discount_gen_mobile/local_notification_service.dart';
import 'package:cafe5_discount_gen_mobile/widget_choose_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  //LocalNotificationService().addNotification(message.notification!.title!, message.notification!.body!);
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.init();
  Config.setString(key_server_address, "37.252.76.8");
  Config.setString(key_server_port, "10002");
  Config.setString(key_server_username, "end1_1@mail.ru");
  Config.setString(key_server_password, "parole");
  Config.setString(key_database_name, "cafe5");
  Config.setInt(key_protocol_version, 1);
  Firebase.initializeApp().then((value) {
      FirebaseMessaging.instance.getToken().then((value) {
        String token = value!;
        print("FIREBASE TOKEN");
        print(token);
        Config.setString(key_firebase_token, token);

        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          LocalNotificationService().addNotification(message.notification!.title!, message.notification!.body!);
        });
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
          LocalNotificationService().addNotification(message.notification!.title!, message.notification!.body!);
        });

      });
  });
  Db.init(dbCreate);
  ClientSocket.init(Config.getString(key_server_address), int.tryParse(Config.getString(key_server_port)) ?? 0);
  await ClientSocket.socket.connect(false);
  await LocalNotificationService().setup();

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
