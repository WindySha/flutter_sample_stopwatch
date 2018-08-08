import 'package:flutter/material.dart';

class LapTimeListItemWidget extends StatelessWidget {
  StopTimeItem item;
  int position;
  int totalSize;

  LapTimeListItemWidget(this.item, this.position, this.totalSize);

  @override
  Widget build(BuildContext context) {
    print("xia build LapTimeListItemWidget position = $position");
    return Column(
      children: <Widget>[
        ListTile(
            title: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    totalSize - position < 10
                        ? "0${totalSize - position}"
                        : "${totalSize - position}",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    maxLines: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                  ),
                  Text("${item.currentTime}"),
                ],
              ),
            ),
            Expanded(
              child: Text(
                "+${item.addedTime}",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        )),
        Divider(
          height: 2.0,
          color: Colors.black38,
        )
      ],
    );
  }
}

class StopTimeItem {
  String currentTime; //当前计数的时间
  String addedTime; //比上次增加的时间

  StopTimeItem(this.currentTime, this.addedTime);
}
