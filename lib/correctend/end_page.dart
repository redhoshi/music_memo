import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_memo/pie_chart/pie.dart';

class EndPage extends StatefulWidget {
  EndPage(this.a, this.i, this.u, this.e, this.o);
  String a = '';
  List i = []; //問題番号
  List u = []; //問題のテキスト
  List e = []; //正解か不正解かaiu
  int o = 0;
  EndPagePage createState() => EndPagePage(a, i, u, e, o);
}

class EndPagePage extends State<EndPage> {
  EndPagePage(this.name, this.e, this.text, this.re, this.val);
  String name;
  List e = []; //問題番号
  List text = []; //問題のテキスト
  List re = []; //正解か不正解かaiu
  int val = 0;
  int per_c = 0;
  int per_i = 0;
  double per_c1 = 0.0;
  double per_i1 = 0.0;
  get child => null; //result
  Future<void> PerChange() async {
    for (int i = 0; i < re.length; i++) {
      if (re[i] != '正解') {
        per_c++;
      } else {
        per_i++;
      }
    }
    per_c1 = (per_c / (per_c + per_i));
    per_i1 = (per_i / (per_c + per_i));
    per_c1 *= 100;
    per_i1 *= 100;
    print('per_c$per_c1');
    print('per_i$per_i');
    // PieChartSample2(e: per_c, o: per_i);
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PerChange();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildsss
    return Scaffold(
      appBar: AppBar(
        title: Text('終了画面'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('【$name】の結果'),
          //PieChartSample2(),
          PieChartSample2(e: per_c1, o: per_i1),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: const Border(
                left: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                right: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                top: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                bottom: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '$val点',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Table(
            border: TableBorder.all(),
            children: [
              for (int i = 0; i < e.length; i++)
                TableRow(children: [
                  Text('第${e[i]}問'),
                  Text('${text[i]}'),
                  Text('${re[i]}')
                ]),
            ],
          ),
        ],
      ),
    );
  }
}
