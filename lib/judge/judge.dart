import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class JudgePage extends StatefulWidget {
  @override
  _JudgePageState createState() => _JudgePageState();
}

class _JudgePageState extends State<JudgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white.withOpacity(0.7),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('aaiueos'),
              RaisedButton(onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => FunkyOverlay(),
                );
              }),
            ],
          ),
          Center(
            child: Text('正解'),
          ),
          Center(
            child: Icon(
              Icons.brightness_1_outlined,
              color: Colors.red,
              size: 300.0,
            ),
          ),
          FloatingActionButton(onPressed: null),
        ],
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  padding: const EdgeInsets.all(160.0),
                  child: Text(
                    '正解',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Icon(Icons.brightness_1_outlined,
                      color: Colors.red, size: 300.0),
                ),
              ),
              //閉じるボタンを作成
            ],
          ),
        ),
      ),
    );
  }
}
