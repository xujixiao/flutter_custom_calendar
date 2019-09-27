import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/style/style.dart';
import 'package:random_pk/random_pk.dart';

/**
 * 自定义一些额外的数据，实现标记功能
 */
class CustomSignPage extends StatefulWidget {
  CustomSignPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CustomSignPageState createState() => _CustomSignPageState();
}

class _CustomSignPageState extends State<CustomSignPage> {
  String text;

  CalendarController controller;

  Map<DateModel, String> customExtraData = {
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -1))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -2))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -3))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -4))): "班",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -5))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -6))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -7))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -8))): "班",
    DateModel.fromDateTime(DateTime.now()): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 1))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 2))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 3))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 4))): "班",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 5))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 6))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 7))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 8))): "班",
  };

  @override
  void initState() {
    text = "${DateTime.now().year}年${DateTime.now().month}月";

    controller = new CalendarController(
        weekBarItemWidgetBuilder: () {
          return CustomStyleWeekBarItem();
        },
        dayWidgetBuilder: (dateModel) {
          return CustomStyleDayWidget(dateModel);
        },
        extraDataMap: customExtraData);

    controller.addMonthChangeListener(
      (year, month) {
        setState(() {
          text = "$year年$month月";
        });
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                new Text(text),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
              calendarController: controller,
            ),
            new Text(
                "自定义创建Item\n选中的时间:\n${controller.getSingleSelectCalendar().toString()}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.toggleExpandStatus();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

class CustomStyleDayWidget extends BaseCombineDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  Widget getNormalWidget(DateModel dateModel) {
    return Container(
      margin: EdgeInsets.all(8),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //公历
              new Expanded(
                child: Center(
                  child: new Text(
                    dateModel.day.toString(),
                    style: currentMonthTextStyle,
                  ),
                ),
              ),

              //农历
              new Expanded(
                child: Center(
                  child: new Text(
                    "${dateModel.lunarString}",
                    style: lunarTextStyle,
                  ),
                ),
              ),
            ],
          ),
          dateModel.extraData != null
              ? Positioned(
                  child: Text(
                    "${dateModel.extraData}",
                    style: TextStyle(fontSize: 10, color: RandomColor.next()),
                  ),
                  right: 0,
                  top: 0,
                )
              : Container()
        ],
      ),
    );
  }

  @override
  Widget getSelectedWidget(DateModel dateModel) {
    return Container(
      margin: EdgeInsets.all(8),
      foregroundDecoration:
          new BoxDecoration(border: Border.all(width: 2, color: Colors.blue)),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //公历
              new Expanded(
                child: Center(
                  child: new Text(
                    dateModel.day.toString(),
                    style: currentMonthTextStyle,
                  ),
                ),
              ),

              //农历
              new Expanded(
                child: Center(
                  child: new Text(
                    "${dateModel.lunarString}",
                    style: lunarTextStyle,
                  ),
                ),
              ),
            ],
          ),
          dateModel.extraData != null
              ? Positioned(
            child: Text(
              "${dateModel.extraData}",
              style: TextStyle(fontSize: 10, color: RandomColor.next()),
            ),
            right: 0,
            top: 0,
          )
              : Container()
        ],
      ),
    );
  }
}
