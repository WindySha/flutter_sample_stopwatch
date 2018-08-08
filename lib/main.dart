import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sample_stopwatch/time_text_widget.dart';
import 'lap_time_list_item.dart';

void main() => runApp(new TimerAppPage());

class TimerAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'This is my Flutter',
      color: Colors.red,
      theme: new ThemeData(primaryColor: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: new Text("stopWatch"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: TimerPage(),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  Stopwatch stopwatch;
  Timer timer;

  final Map<int, ValueChanged<String>> timerListeners =
      Map<int, ValueChanged<String>>();

  final List<ValueChanged<StopTimeItem>> timeListListener =
      List<ValueChanged<StopTimeItem>>();

  List<StopTimeItem> stopTimeList = List<StopTimeItem>();

  int lastRecordedTime = 0;

  TimerPageState() {
    stopwatch = new Stopwatch();
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      timerListeners.forEach((key, value) {
        if (key == TimeType.MinuteSecondType) {
          value(TimerTextFormatter.formatSecond(stopwatch.elapsedMilliseconds));
        } else {
          value(TimerTextFormatter.formatMilli(stopwatch.elapsedMilliseconds));
        }
      });
    }
  }

  void pauseStartButtonPressed() {
    if (stopwatch.isRunning) {
      String formattedTime =
          TimerTextFormatter.format(stopwatch.elapsedMilliseconds);
      String formattedAddedTime = TimerTextFormatter
          .format(stopwatch.elapsedMilliseconds - lastRecordedTime);
      stopTimeList.add(StopTimeItem(formattedTime, formattedAddedTime));
      print("${stopwatch.elapsedMilliseconds}");
      lastRecordedTime = stopwatch.elapsedMilliseconds;

      timeListListener.forEach((list) {
        list(StopTimeItem(formattedTime, formattedAddedTime));
      });
      return;
    }
    setState(() {
      if (!stopwatch.isRunning) {
        stopTimeList.clear();
        stopwatch.reset();
        lastRecordedTime = 0;

        timerListeners.forEach((key, value) {
          if (key == TimeType.MinuteSecondType) {
            value(TimerTextFormatter.formatSecond(0));
          } else {
            value(TimerTextFormatter.formatMilli(0));
          }
        });
      }
    });
  }

  void countButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        stopwatch.stop();
        timer.cancel();
        timer = null;
      } else {
        timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
        stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: new Text(text, style: roundTextStyle),
        onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    print("xia -- build TimerPage !!!");
    return new Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 25.0),
            child: new Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TimeTextWidget(
                    timerListeners: timerListeners,
                    timeType: TimeType.MinuteSecondType,
                  ),
                  TimeTextWidget(
                    timerListeners: timerListeners,
                    timeType: TimeType.MilliType,
                  ),
                ],
              ),
            )),
        Container(
          padding: const EdgeInsets.only(top: 25.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildFloatingButton(
                    stopwatch.isRunning ? "计数" : "复位", pauseStartButtonPressed),
                buildFloatingButton(
                    stopwatch.isRunning ? "暂停" : "开始", countButtonPressed),
              ]),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 25.0),
              child: new Center(
                child: new TimeListWidget(
                  stopTimeList: stopTimeList,
                  timeListListener: timeListListener,
                ),
              )),
        )
      ],
    );
  }
}

class TimeListWidget extends StatefulWidget {
  TimeListWidget({this.stopTimeList, this.timeListListener});

  List<ValueChanged<StopTimeItem>> timeListListener;
  List<StopTimeItem> stopTimeList;

  @override
  TimeListState createState() => TimeListState();
}

class TimeListState extends State<TimeListWidget> {
  @override
  void initState() {
    widget.timeListListener.add((list) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int size = widget.stopTimeList.length;
    return ListView.builder(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      itemCount: size,
      itemBuilder: (context, index) {
        return LapTimeListItemWidget(
            widget.stopTimeList[size - index - 1], index, size);
      },
    );
  }
}
