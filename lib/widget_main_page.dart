import 'dart:typed_data';

import 'package:cviewdiscount/base_widget.dart';
import 'package:cviewdiscount/class_outlinedbutton.dart';
import 'package:cviewdiscount/config.dart';
import 'package:cviewdiscount/home_page.dart';
import 'package:cviewdiscount/socket_message.dart';
import 'package:cviewdiscount/translator.dart';
import 'package:cviewdiscount/utils/ColorHelper.dart';
import 'package:cviewdiscount/widget_bonuses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WidgetMainPage extends StatefulWidget {
  const WidgetMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetMainPageState();
  }
}

class WidgetMainPageState extends BaseWidgetState
    with TickerProviderStateMixin {
  bool _hideMenu = true;
  double startx = 0;
  int _menuAnimationDuration = 300;
  String _qr = "";

  @override
  void dispose() {
    super.dispose();
  }

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
        case SocketMessage.op_create_qr_discount:
          setState(() {
            _qr = m.getString();
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.background_color,
        body: SafeArea(
            minimum:
                const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Stack(
                children: [
              Container(color: ColorHelper.background_color,),
              Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Container()),
                      Text(Config.getString(key_fullname),
                          style: TextStyle(fontWeight: FontWeight.bold, color: ColorHelper.text_color)),
                      Expanded(child: Container()),
                      ClassOutlinedButton.createImage(() {
                        setState(() {
                          _hideMenu = false;
                          startx = 0;
                          _menuAnimationDuration = 300;
                        });
                      }, "assets/images/menu.png"),
                    ]),
                    const Divider(
                      height: 20,
                    ),
                    Align(alignment: Alignment.center, child: Container(width: 100, height: 100, child: InkWell(onTap: () {
                      sq(tr("Create new discount card?"), () {
                        SocketMessage m = SocketMessage.dllplugin(
                            SocketMessage.op_create_qr_discount);
                        sendSocketMessage(m);
                      }, () {});
                    }, child: Image.asset("assets/images/plus.png")))),
                    ClassOutlinedButton.create(() {
                      sq(tr("Create new discount card?"), () {
                        SocketMessage m = SocketMessage.dllplugin(
                            SocketMessage.op_create_qr_discount);
                        sendSocketMessage(m);
                      }, () {});
                    }, tr("Generate"), w: double.infinity),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 300,
                                height: 300,
                                color: Colors.white,
                                child: Visibility(
                                  visible: _qr.isNotEmpty,
                                  child: QrImage(
                                    data: _qr,
                                    version: QrVersions.auto,
                                    size: 300.0,
                                  ),
                                )))),
                    ClassOutlinedButton.create(() {
                      if (_qr.isEmpty) {
                        sd(tr("Empty QR code"));
                        return;
                      }
                      Share.share(
                          'CView 10% discount https://cview.am/discountapp/hand/$_qr.png',
                          subject: 'CView 10% discount');
                      //Share.share('CView 10% discount https://cview.am/discountapp/hand/0b1f9e6b-6dcf-4d21-9a1f-adc9ac08c8f6.png', subject: 'CView 10% discount');
                    }, tr("Send link"), w: double.infinity),
                    const Divider(
                      height: 20,
                    )
                  ]),
              _menu()
            ])));
  }

  Widget _menu() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _menuAnimationDuration),
      top: 0,
      right: _hideMenu ? -1 * (MediaQuery.of(context).size.width) : startx,
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
          onTap: () {
            setState(() {
              _hideMenu = true;
              _menuAnimationDuration = 300;
            });
          },
          onPanStart: (details) {
            setState(() {
              _menuAnimationDuration = 1;
            });
          },
          onPanUpdate: (details) {
            if (startx - details.delta.dx > 0) {
              return;
            }
            setState(() {
              startx -= details.delta.dx;
            });
          },
          onPanEnd: (details) {
            setState(() {
              if (startx < -120) {
                _hideMenu = true;
              } else {
                startx = 0;
              }
              _menuAnimationDuration = 300;
            });
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width / 3),
                child: Container(
                    color: const Color(0xffcccccc),
                    child: Column(
                      children: [
                        Container(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(child: Container()),
                            ClassOutlinedButton.createImage(() {
                              setState(() {
                                _hideMenu = true;
                              });
                            }, "assets/images/cancel.png")
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        ClassOutlinedButton.create(() {
                          setState(() {
                            _hideMenu = true;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const WidgetBonusPage()));
                          });
                        }, tr("Bonuses"), w: double.infinity),
                        const Divider(
                          height: 20,
                        ),
                        ClassOutlinedButton.create(_launchInsta, tr("Instagramm"), w: double.infinity),
                        const Divider(
                          height: 20,
                        ),
                        ClassOutlinedButton.create(_changeLanguage, tr("Language"), w: double.infinity),
                        const Divider(
                          height: 20,
                        ),
                        ClassOutlinedButton.create(() {
                          setState(() {
                            sq(tr("Confirm to logout"), () {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              if (auth.currentUser != null) {
                                auth.signOut();
                              }
                              Config.setString(key_session_id, "");
                              Config.setBool(key_data_dont_update, false);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WidgetHome()),
                                  (route) => false);
                            }, () {});
                          });
                        }, tr("Logout"), w: double.infinity),
                        Expanded(child: Container())
                      ],
                    )),
              )
            ],
          )),
    );
  }

  void _launchInsta() async {
    const nativeUrl = "instagram://c.view.yvn?igshid=YmMyMTA2M2Y=";
    const webUrl = "https://instagram.com/c.view.yvn?igshid=YmMyMTA2M2Y=";
    if (await canLaunchUrlString(nativeUrl)) {
      await launchUrlString(nativeUrl);
    } else if (await canLaunchUrlString(webUrl)) {
      await launchUrlString(webUrl);
    } else {
      print("can't open Instagram");
    }
  }

  void _changeLanguage() async {
    List<Widget> tiles = List.from(<Widget>[]);
    tiles.add(ListTile(
      dense: true,
      title: const Text('Հայերեն'),
      onTap: ((){
        Navigator.pop(context);
        _hideMenu = true;
        setState(() {
          Config.setString(key_used_language, 'am');
        });
      }),
    ));
    tiles.add(ListTile(
      dense: true,
      title: const Text('Русский'),
      onTap: ((){
        Navigator.pop(context);
        _hideMenu = true;
        setState(() {
          Config.setString(key_used_language, 'ru');
        });
      }),
    ));
    tiles.add(ListTile(
      dense: true,
      title: const Text('English'),
      onTap: ((){
        Navigator.pop(context);
        _hideMenu = true;
        setState(() {
          Config.setString(key_used_language, 'en');
        });
      }),
    ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
              child: SimpleDialog(
            backgroundColor: Colors.white,
              children: tiles
          ));
    });
  }
}
