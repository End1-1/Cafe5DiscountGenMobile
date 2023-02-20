import 'dart:typed_data';

import 'package:cviewdiscount/base_widget.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/screens/sms/sms.dart';
import 'package:cviewdiscount/socket_message.dart';
import 'package:cviewdiscount/translator.dart';
import 'package:cviewdiscount/widget_main_page.dart';
import 'package:cviewdiscount/widgets/CViewToast.dart';
import 'package:cviewdiscount/widgets/costum_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cviewdiscount/widgets/costum_button.dart';
import 'package:cviewdiscount/utils/ColorHelper.dart';

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
        backgroundColor: ColorHelper.background_color,
        body: SafeArea(
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Divider(
                height: 40,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        tr("Phone number"),
                        style: TextStyle(
                            color: ColorHelper.title_text_color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))),
              const Divider(
                height: 40,
              ),
              Align(
                  alignment: Alignment.center,
                  child: CostumNumberTextField(
                      prefixString: '+374', controller: _phoneController, enabled: !_dataLoading,)),
              const Divider(
                height: 40,
              ),
              Align(
                  child: CostumButton(
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width / 4),
                onPressed: _authByPhone,
                child: Text(
                  tr("Next"),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: 24),
                ),
              )),
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

  void _authByPhone() async {
    if (_dataLoading) {
      return;
    }
    if (_phoneController.text.isEmpty) {
      CViewToast(tr("Phone number cannot be empty"));
      return;
    }
    if (_phoneController.text == '7777778') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WidgetSMS(
                    verificationId: '',
                    phoneNumber: '+374 ${_phoneController.text}',
                  )));
    }
    setState(() {
      _dataLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 120),
        phoneNumber: '+374${_phoneController.text}',
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      WidgetSMS(
                          phoneNumber: '+374 ${_phoneController.text}',
                          verificationId: verificationId)));
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          print(phoneAuthCredential.smsCode);
        },
        verificationFailed: (FirebaseAuthException error) {
          print(error);
          CViewToast(error.toString());
        },
        codeAutoRetrievalTimeout: (String verificationId) {

        },
      );
    }
  }
}
