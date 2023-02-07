import 'dart:convert';
import 'dart:typed_data';
import 'package:cafe5_discount_gen_mobile/server_config.dart';
import 'package:flutter/material.dart';
import 'package:cafe5_discount_gen_mobile/config.dart';
import 'package:cafe5_discount_gen_mobile/base_widget.dart';
import 'package:cafe5_discount_gen_mobile/socket_message.dart';
import 'package:cafe5_discount_gen_mobile/home_page.dart';
import 'package:http/http.dart' as http;

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
    print("command ${m.command}");
    switch (m.command) {
      case SocketMessage.c_hello:
        m = SocketMessage(messageId: SocketMessage.messageNumber(), command: SocketMessage.c_auth);
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
  void connected(){
    print("WidgetChooseSettings.connected()");
    SocketMessage.resetPacketCounter();
    SocketMessage m = SocketMessage(messageId: SocketMessage.messageNumber(), command: SocketMessage.c_hello);
    sendSocketMessage(m);
  }

  @override
  void authenticate() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHome()), (route) => false);
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHome()));
  }

  @override
  void disconnected() {
    setState((){});
  }

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ClientSocket.socket == null) {
        _getIpAddress();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage(ClientSocket.imageConnectionState()),)
              ),
            ]
        )
    );
  }

  void _getIpAddress() async {
    http.get(Uri.parse('https://cview.am/discountapp/ip.html')).then((response) async {
      if (response.statusCode == 200) {
        ServerConfig sc = ServerConfig.fromJson(jsonDecode(response.body));
        ClientSocket.init(sc.ip, int.tryParse(sc.port) ?? 0);
        ClientSocket.socket!.connect(false);
      } else {
        const int sec = 2;
        print("Wait $sec second");
        _getIpAddress();
        print("retry http request");
      }
    });
  }
}