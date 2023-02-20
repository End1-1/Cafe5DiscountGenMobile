import 'dart:typed_data';

import 'package:cviewdiscount/base_widget.dart';
import 'package:cviewdiscount/class_outlinedbutton.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/socket_message.dart';
import 'package:cviewdiscount/translator.dart';
import 'package:flutter/material.dart';

import 'Utils/ColorHelper.dart';

class WidgetBonusPage extends StatefulWidget {
  const WidgetBonusPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetBonusPageState();
  }
}

class WidgetBonusPageState extends BaseWidgetState with TickerProviderStateMixin {
  int _bonus = 0;

  @override
  void handler(Uint8List data) async {
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);
    if (!checkSocketMessage(m)) {
      return;
    }
    print("command ${m.command}");
    if (m.command == SocketMessage.c_dllplugin) {
      int op = m.getInt();
      int dllok = m.getByte();
      if (dllok == 0) {
        sd(tr(m.getString()));
        return;
      }
      switch (op) {
        case SocketMessage.op_check_bonus:
          setState((){
            _bonus = m.getInt();
          });
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_check_bonus);
      sendSocketMessage(m);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.background_color,
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Stack(children: [
              Container(color: ColorHelper.background_color),
              Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      ClassOutlinedButton.createImage(() {
                        Navigator.pop(context);
                      }, "assets/images/back.png"),
                      Expanded(child: Container()),
                      Text(Config.getString(key_fullname), style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Container()),

                    ]),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "${tr("Bonuses")}: \n$_bonus", textAlign: TextAlign.center,
                              style: TextStyle(color: ColorHelper.button_background_gradient1, fontSize: 30, fontWeight: FontWeight.bold),
                            ))),
                  ])
            ])));
  }
}
