import 'dart:convert';

import 'package:cviewdiscount/server_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/widget_choose_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'client_socket.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initialization();
  }

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

  void initialization() async {
    await Firebase.initializeApp();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await remoteConfig.fetchAndActivate();
    String jsonConfigStr = remoteConfig.getString("server_config");
    Map<String, dynamic>? config = jsonDecode(jsonConfigStr);
    if (config != null) {
      print(jsonConfigStr);
      await Config.init();
      ClientSocket.init(config![key_server_address], int.tryParse(config![key_server_port]) ?? 0);
    }
    jsonConfigStr = remoteConfig.getString("app_config");
    config = jsonDecode(jsonConfigStr);
    if (config != null) {
      Config.setConfig(config);
    }
    FlutterNativeSplash.remove();
  }
}