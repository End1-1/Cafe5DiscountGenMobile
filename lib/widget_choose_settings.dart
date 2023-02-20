import 'dart:typed_data';
import 'package:cviewdiscount/translator.dart';
import 'package:cviewdiscount/widget_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/base_widget.dart';
import 'package:cviewdiscount/socket_message.dart';
import 'package:cviewdiscount/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'Utils/ColorHelper.dart';
import 'client_socket.dart';

class WidgetChooseSettings extends StatefulWidget {
  const WidgetChooseSettings({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetChooseSettingsState();
  }
}

class WidgetChooseSettingsState extends BaseWidgetState<WidgetChooseSettings> {
  @override
  void handler(Uint8List data) {
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);
    if (!checkSocketMessage(m)) {
      return;
    }
    if (m.command == SocketMessage.c_dllplugin) {
      int op = m.getInt();
      int dllok = m.getByte();
      if (dllok == 0) {
        sd(m.getString());
        return;
      }
    }
    switch (m.command) {
      case SocketMessage.c_hello:
        m = SocketMessage(
            messageId: SocketMessage.messageNumber(),
            command: SocketMessage.c_auth);
        m.addString(Config.getString(key_server_username));
        m.addString(Config.getString(key_server_password));
        sendSocketMessage(m);
        break;
      case SocketMessage.c_auth:
        int userid = m.getInt();
        if (userid > 0) {
          ClientSocket.setSocketState(2);
        }
        break;
    }
  }

  @override
  void connected() {
    print("WidgetChooseSettings.connected()");
    SocketMessage.resetPacketCounter();
    SocketMessage m = SocketMessage(
        messageId: SocketMessage.messageNumber(),
        command: SocketMessage.c_hello);
    sendSocketMessage(m);
  }

  @override
  void authenticate() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => WidgetHome()),
              (route) => false);
    } else {
      auth.currentUser!.reload();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const WidgetMainPage()),
              (route) => false);
    }
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHome()));
  }

  @override
  void disconnected() {
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.background_color,
        body: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset("assets/images/noconnection.svg")),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                      tr(
                          "No connection to server.\nCheck internet connection."),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorHelper.text_color)))
            ]));
  }
}
