
import 'dart:async';

import 'package:flutter/foundation.dart';

const timeoutSeconds = 60;

class TimerProvider with ChangeNotifier {
  bool wait = false;
  int start = timeoutSeconds;
  bool isActionBarShow = false;
  startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        timer.cancel();
        wait = false;
        isActionBarShow = true;
        notifyListeners();
      } else {
        start--;
        wait = true;
        notifyListeners();
      }
    });
  }

  resetTimer() {
    start = timeoutSeconds;
    isActionBarShow = false;
    notifyListeners();
  }
}
