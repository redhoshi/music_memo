import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_memo/pie_chart/indicator.dart';
//import 'package:flutter/src/rendering/object.dart';

class PieChartSample2 extends StatefulWidget {
  double e;
  double o;
  PieChartSample2({required this.e, required this.o});

  @override
  State<StatefulWidget> createState() => PieChart2State(e, o);
}

class PieChart2State extends State {
  int touchedIndex = -1;
  PieChart2State(this.cor, this.incor);
  double cor;
  double incor;

  @override
  Widget build(BuildContext context) {
    //return Scaffold(
    final double deviceheight = MediaQuery.of(context).size.height;

    return AspectRatio(
      aspectRatio: 1.3,
      //body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*
          new SizedBox(
            height: deviceheight * 0.02, //18
          ),*/
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch =
                            pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                        if (desiredTouch &&
                            pieTouchResponse.touchedSection != null) {
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    }),
                    startDegreeOffset: -90, //最初の角度の変更
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0, //輪の太さ
                    sections: showingSections()),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Color(0xffff5252),
                text: '正解',
                isSquare: true,
              ),
              /*
              SizedBox(
                height: 3,
              ),*/
              Indicator(
                color: Color(0xff0293ee),
                text: '不正解',
                isSquare: true,
              ),
              /*
              SizedBox(
                height: 3,
              ),*/
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
      //),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xffff5252),
            value: cor,
            title: '${cor.toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: incor,
            title: '${incor.toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }
}
