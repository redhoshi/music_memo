import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:music_memo/calender/resultresearch.dart';

class CalenderExample extends StatefulWidget {
  const CalenderExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CalenderExampleState();
  }
}

class _CalenderExampleState extends State<CalenderExample> {
  //カレンダーに表示する用
  final _currentDate = DateTime.now();
  //検索する用
  final now = DateTime.now();

  Future<void> SetDate(now) async {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);
    print('noe$date');
    setState(() {});
  }

  Future<void> onDayPressed(DateTime date, List<Event> events) async {
    //this.setState(() => _currentDate = date);
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(_currentDate);
    print(date);

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(date), //ファイル名と引数
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
        body: Container(
          child: CalendarCarousel<Event>(
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
        ));
  }
}
