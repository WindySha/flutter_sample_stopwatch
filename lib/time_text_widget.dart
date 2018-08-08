import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimeTextWidget extends StatefulWidget {
  final Map<int, ValueChanged<String>> timerListeners;

  final int timeType;

  TimeTextWidget({this.timerListeners, this.timeType});

  @override
  State<StatefulWidget> createState() => TimeTextWidgetState();
}

class TimeTextWidgetState extends State<TimeTextWidget> {
  String currentFormatedTime;

  TimeTextWidgetState() {
    print("xia -- SecondTextState !!!");
  }

  @override
  void initState() {
    if (widget.timeType == TimeType.MinuteSecondType) {
      widget.timerListeners.addAll({TimeType.MinuteSecondType: _valueChanged});
      currentFormatedTime = TimerTextFormatter.formatSecond(0);
    } else {
      widget.timerListeners.addAll({TimeType.MilliType: _valueChanged});
      currentFormatedTime = TimerTextFormatter.formatMilli(0);
    }
  }

  void _valueChanged(String elapsedTime) {
//    print("xia -- build _valueChanged elapsedTime = $elapsedTime currentFormatedTime = $currentFormatedTime ");
    if (elapsedTime != currentFormatedTime) {
      setState(() {
        currentFormatedTime = elapsedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    print("xia -- build SecondText !!!");
    final TextStyle timerTextStyle =
        const TextStyle(fontSize: 60.0, fontFamily: "Open Sans");
    return new Text(currentFormatedTime, style: timerTextStyle);
  }
}

class TimerTextFormatter {
  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }

  static String formatSecond(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.";
  }

  static String formatMilli(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$hundredsStr";
  }
}

class TimeType {
  static int MinuteSecondType = 0;
  static int MilliType = 1;
}
