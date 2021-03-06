import 'dart:math';
import 'package:flutter/material.dart';

class WavePage extends StatefulWidget {
  WavePage({Key? key, required this.h}) : super(key: key);
  double h;
  //WavePage(this.h);
  @override
  _WavePageState createState() => _WavePageState(h);
}

class _WavePageState extends State<WavePage> with TickerProviderStateMixin {
  _WavePageState(this.tall);
  double tall;

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: false);
    _animationController.repeat(
      period: Duration(milliseconds: 1000), // 波紋が作成される速度
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    return Container(
      //height: 100, //他のオブジェクトに影響する
      //width: 100,
      //scafold入れると
      child: CustomPaint(
        painter: SpritePainter(_animationController, deviceheight),
        /*
        child: SizedBox(
          //widthは大きさが変わるheightは何も変わらん
          width: 300.0,
          height: 300.0,
          child: Text('$tall'),
        ),*/
      ),
    );
  }
}

class SpritePainter extends CustomPainter {
  //double ta;

  final Animation<double> _animation;
  final double deviceheight;
  SpritePainter(this._animation, this.deviceheight)
      : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0); // 透明度の設定
    Color color = Color.fromRGBO(188, 175, 237, opacity); // 色の設定

    // print(rect);
    double size = rect.width * deviceheight * 1.2; //半径の長さ？*1000
    double area = size * size;
    double radius = sqrt(area * value / 4);

    final Paint paint = Paint()..color = color;
    canvas.drawCircle(rect.centerLeft, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(
        0.1, 0, size.width, size.height); //LTWH,left,top,width,height0.1*1000

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return false;
  }
}
