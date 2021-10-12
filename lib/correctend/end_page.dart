import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_memo/first.dart';
import 'package:music_memo/main.dart';
import 'package:music_memo/pie_chart/pie.dart';
import 'package:music_memo/thanks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class EndPage extends StatefulWidget {
  EndPage(this.a, this.i, this.u, this.e, this.o, this.isended1, this.isended2,
      this.isended3);
  String a = '';
  List i = []; //問題番号
  List u = []; //問題のテキスト
  List e = []; //正解か不正解かaiu
  int o = 0;
  bool isended1, isended2, isended3;
  EndPagePage createState() =>
      EndPagePage(a, i, u, e, o, isended1, isended2, isended3);
}

class EndPagePage extends State<EndPage> {
  EndPagePage(this.name, this.e, this.text, this.re, this.val, this._isEnded1,
      this._isEnded2, this._isEnded3);
  String name;
  List e = []; //問題番号
  List text = []; //問題のテキスト
  List re = []; //正解か不正解かaiu
  int val = 0;
  bool _isEnded1, _isEnded2, _isEnded3;
  bool last = false;
  int per_c = 0;
  int per_i = 0;
  double per_c1 = 0.0;
  double per_i1 = 0.0;
  get child => null; //result

  //円グラフの正解・不正解の割合を求める
  Future<void> perChange() async {
    for (int i = 0; i < re.length; i++) {
      if (re[i] == '正解') {
        per_c++;
      } else {
        per_i++;
      }
    }
    //percet
    per_c1 = (per_c / (per_c + per_i));
    per_i1 = (per_i / (per_c + per_i));
    per_c1 *= 100;
    per_i1 *= 100;
    print('per_c$per_c1');
    print('per_i$per_i1');
    inputData(per_c1, per_c, per_i);
  }

  //cloudfirestoreにデータを格納
  Future<void> inputData(per, perc, peri) async {
    final now = new DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);
    await FirebaseFirestore.instance.collection('userre').doc('$name').set({
      'date': '$date',
      'correct': '$per',
      '正解': '$perc',
      '不正解': '$peri',
    });
  }

  Future<void> checkEnded() async {
    if (_isEnded1 == true && _isEnded2 == true && _isEnded3 == true) {
      last = true;
      print('lastがtrueになる$last');
    }
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    perChange();
    //InputData();正答率出すのならperchangeから呼び出す
    checkEnded();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double devicewidth = MediaQuery.of(context).size.width;
    // TODO: implement buildsss
    return Scaffold(
      appBar: AppBar(
        title: Text('$nameさんの結果'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Text('【$deviceheightさん】の結果'), //name

          //PieChartSample2(),

          PieChartSample2(e: per_c1, o: per_i1),
          /*
          new SizedBox(
            height: deviceheight * 0.021,
          ),*/
          new SizedBox(
            height: deviceheight * 0.3,
            width: devicewidth * 1.0,
            child: Table(
              border: TableBorder.all(),
              children: [
                for (int i = 0; i < e.length; i++)
                  TableRow(children: [
                    Center(
                        child: Text(
                      '第${e[i] + 1}問',
                      style: TextStyle(fontSize: 12),
                    )),
                    Center(
                        child: Text(
                      '${text[i].replaceFirst('の音を選択してください', '')}',
                      style: TextStyle(fontSize: 12),
                    )),
                    Center(
                        child: Text(
                      '${re[i]}',
                      style: TextStyle(fontSize: 12),
                    ))
                  ]),
              ],
            ),
          ),
          new SizedBox(
            height: deviceheight * 0.07,
            width: devicewidth * 0.34,
            child: FloatingActionButton.extended(
                onPressed: () {
                  last
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ThanksPage()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FirstPage(name, _isEnded1,
                                  _isEnded2, _isEnded3))); //first.dartにいく
                },
                label: last ? Text('終了する') : Text('Homeへ戻る')),
          ),
        ],
      ),
    );
  }
}
