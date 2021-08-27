import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:music_memo/calender/resultresearch.dart';
import 'package:music_memo/line_chart/line_chart.dart';

class CalenderExample extends StatefulWidget {
  //const CalenderExample({Key? key}) : super(key: key);
  CalenderExample(this.user);
  String user;

  @override
  State<CalenderExample> createState() => _CalenderExampleState(user);
  /*
  State<StatefulWidget> createState() {
    return _CalenderExampleState();
  }*/
}

class _CalenderExampleState extends State<CalenderExample> {
  //userメイト
  _CalenderExampleState(this.user);
  String user;

  //カレンダーに表示する用
  DateTime _currentDate = DateTime.now();

  //検索する用
  final now = DateTime.now();

  Future<void> SetDate(now) async {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);
    print('noe$date');
    setState(() {});
  }

  Future<void> onDayPressed(final date, List<Event> events) async {
    this.setState(() => _currentDate = date);
    print(date);
    String ya = date.toString().substring(0, 10);
    print('${ya}');
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(ya), //ファイル名と引数
        ));
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Calender Example"),
        ),
        body: Column(children: <Widget>[
          SizedBox(
            height: 20,
            child: Text('ようこそ ユーザー$userさん'),
          ),
          CalendarCarousel<Event>(
              onDayPressed: onDayPressed,
              weekendTextStyle: TextStyle(color: Colors.red),
              thisMonthDayBorderColor: Colors.grey,
              weekFormat: false,
              height: 420.0,
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: false,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              markedDateShowIcon: true,
              markedDateIconMaxShown: 2,
              todayTextStyle: TextStyle(
                color: Colors.blue,
              ),
              markedDateIconBuilder: (event) {
                return event.icon;
              },
              todayBorderColor: Colors.green,
              markedDateMoreShowTotal: false),
          new SizedBox(
            height: 20,
          ),
          LineChartSample2(),
        ]));
  }
}
