import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  final date = []; //日付のリスト
  final corr = []; //正答率のリスト
  final datea = []; //日付(割り当て用)
  final cora = []; //正答率(割り当て用)
  final j = []; //真ん中
  int f = 5;

  Future<void> Dataset() async {
    await FirebaseFirestore.instance.collection('userre').get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) async {
                date.add(doc.id); //[2021-08-16,]
              },
            ),
          },
        );
    for (int i = 0; i < date.length; i++) {
      final snepshot = await FirebaseFirestore.instance
          .collection('userre')
          .doc(date[i])
          .get();
      corr.add(snepshot['correct']);
    }
    print('date$date');
    print('correct$corr');
    Separate(date, corr);
  }

  Future<void> Separate(dat, cor) async {
    j.add((dat.length / 2).toInt());
    //データがなにもない時
    if (dat.length < 1) {
      for (int i = 0; i < 3; i++) {
        cora.add(0.0);
      }
      print('corr0:$corr');
      setState(() {});
    } else if (dat.length < 3) {
      //1個か2個
      if (dat.length == 1) {
        for (int i = 0; i < dat.length - 1; i++) {
          cora.add(cor[i]);
        }
        cora.add(0.0);
        cora.add(0.0);
      } else {
        for (int i = 0; i < dat.length - 1; i++) {
          cora.add(cor[i]);
        }
        cora.add(0.0);
      }
      setState(() {});
    } else {
      //0を入力
      datea.add(dat[0]);
      cora.add(cor[0]);
      //真ん中
      datea.add(dat[j[0]]);
      cora.add(cor[j[0]]);
      //最後
      datea.add(dat[dat.length - 1]);
      cora.add(cor[dat.length - 1]);
      print('datea$datea');
      print('cora$cora');
      print('j:${date[j[0]]}');
      print('datea${datea.length}');
      setState(() {}); //描画されない→された
    }
    print('$corr');
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Dataset();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                //showAvg ? avgData() :
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return datea.length > 2 ? '${datea[0]}' : 'まだ';
              case 5:
                return datea.length > 2 ? '${datea[1]}' : '表に';
              case 9:
                return datea.length > 2 ? '${datea[2]}' : 'できません';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '10';
              case 50:
                return '50';
              case 100:
                return '100';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 100,
      //cloudfirestore
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < corr.length; i++)
              FlSpot(i.toDouble(), double.parse(corr[i])),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
