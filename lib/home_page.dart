import 'dart:typed_data';

import 'package:cviewdiscount/base_widget.dart';
import 'package:cviewdiscount/class_outlinedbutton.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/screens/sms/sms.dart';
import 'package:cviewdiscount/socket_message.dart';
import 'package:cviewdiscount/translator.dart';
import 'package:cviewdiscount/widget_main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Utils/ColorHelper.dart';

class WidgetHome extends StatefulWidget {
  WidgetHome({super.key}) {
    print("Create WidgetHome");
  }

  @override
  State<StatefulWidget> createState() {
    return WidgetHomeState();
  }
}

class WidgetHomeState extends BaseWidgetState with TickerProviderStateMixin {
  bool _dataLoading = false;
  String _progressString = "";
  late AnimationController animationController;
  final TextEditingController _phoneController = TextEditingController();

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
        backgroundColor:
            ColorHelper.fromHex(Config.getString(key_background_color)),
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
                        tr("Phone number"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ))),
              Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text('+374',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                      ),
                      Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                  controller: _phoneController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.greenAccent))))))
                    ],
                  )),
              Align(
                  child: TextButton(
                      onPressed: _authByPhone,
                      child: Text(
                        tr("Next"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ))),
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

  // void _authByPhone() async {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: '+374 ${_phoneController.text}',
  //       codeSent: (String verificationId, int? resendToken) async {
  //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetSMS(verificationId: verificationId)));
  //       },
  //       verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
  //         print(phoneAuthCredential.smsCode);
  //       },
  //       verificationFailed: (FirebaseAuthException error) {
  //         print(error);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {  },
  //     );
  //
  // }

  void _authByPhone() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WidgetSMS(
                  verificationId: "",
                  phoneNumber: '+374 ${_phoneController.text}',
                )));
  }
}
