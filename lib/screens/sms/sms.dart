import 'dart:typed_data';

import 'package:cviewdiscount/base_widget.dart';
import 'package:cviewdiscount/class_outlinedbutton.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/socket_message.dart';
import 'package:cviewdiscount/translator.dart';
import 'package:cviewdiscount/widget_main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../home_page.dart';

class WidgetSMS extends StatefulWidget {

  final String verificationId;
  final String phoneNumber;

  WidgetSMS({super.key, required this.verificationId, required this.phoneNumber}) {

  }

  @override
  State<StatefulWidget> createState() {
    return WidgetSMSState();
  }
}

class WidgetSMSState extends BaseWidgetState<WidgetSMS> with TickerProviderStateMixin {
  bool _dataLoading = false;
  String _progressString = "";
  late AnimationController animationController;
  final TextEditingController _smsController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      setState(() {});
    });
    animationController.repeat(reverse: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Config.getString(key_session_id).isNotEmpty) {
        SocketMessage m =
        SocketMessage.dllplugin(SocketMessage.op_login_pashhash);
        m.addString(Config.getString(key_session_id));
        m.addString(Config.getString(key_firebase_token));
        sendSocketMessage(m);
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void handler(Uint8List data) async {
    _dataLoading = false;
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
        case SocketMessage.op_login:
          Config.setString(key_session_id, m.getString());
          Config.setString(key_fullname, m.getString());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => WidgetMainPage()),
                  (route) => false);
          break;
        case SocketMessage.op_login_pashhash:
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => WidgetMainPage()),
                  (route) => false);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            tr("Code from SMS"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            widget.phoneNumber,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
                  Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [

                          Expanded(child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 24),
                                  controller: _smsController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(

                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.greenAccent))))))
                        ],
                      )),
                  Align(child: TextButton(onPressed: _verifySMS, child: Text(tr("Confirm"), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)))),
                  Align(
                      child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Visibility(
                              visible: _dataLoading,
                              child: CircularProgressIndicator(
                                value: animationController.value,
                              )))),
                  Align(
                    child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Visibility(
                            visible: _progressString.isNotEmpty,
                            child: Text(_progressString))),
                  )
                ])));
  }



  void _verifySMS() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WidgetMainPage()),
            (route) => false);
    // FirebaseAuth auth = FirebaseAuth.instance;
    // setState(() {
    //   _dataLoading = true;
    // });
    // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: _smsController.text);
    //
    // try {
    //   await auth.signInWithCredential(credential);
    //   print(credential);
    // } catch (e) {
    //   print(e);
    // }
    // setState((){
    //   _dataLoading = false;
    // });
  }
}
