import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_memo/Login/login.dart';
import 'package:music_memo/main.dart';
import 'dart:math' as math;

class FirstPage extends StatefulWidget {
  //const FirstPage({Key? key}) : super(key: key);
  FirstPage(this.user);
  String user;

  @override
  State<FirstPage> createState() => _FirstPageState(user);
}

class _FirstPageState extends State<FirstPage> {
  _FirstPageState(this.user);
  String user;
  bool _isEnded1 = false;
  final num = List<int>.generate(3, (i) => i + 0);
  final sound = ['sound', 'sound2', 'sound3'];
  final question = ['question', 'question2', 'question3'];

  calcurate(aiu) async {
    var dat;
    for (int j = 0; j < aiu.length; j++) {
      int lottery = math.Random().nextInt(j + 1);
      dat = aiu[j];
      aiu[j] = aiu[lottery];
      aiu[lottery] = dat;
    }
  }

  @override
  Widget build(BuildContext context) {
    calcurate(num);
    print(num);
    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
        centerTitle: true,
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //if (user.isEmpty)
          Center(
            child: Text(
              'ようこそ $userさん',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),

          Center(
            child: Text(
              'Section1-3のボタンを押すと問題に進むことができます。\nどのSectionから始めても構いません。\n全てのSectionを完了させてください。',
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            'Section 1',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
          ),
          new SizedBox(
            width: 100,
            height: 100,
            child: NeumorphicFloatingActionButton(
              child: Icon(Icons.campaign_sharp, size: 30),
              onPressed: _isEnded1 //trueなら押せなくする
                  ? null
                  : () async {
                      print('$num');
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                user, sound[num[0]], question[num[0]]), //sound
                          ));
                    },
            ),
          ),
          Text(
            'Section2',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
          ),
          new SizedBox(
            width: 100,
            height: 100,
            child: NeumorphicFloatingActionButton(
              child: Icon(Icons.construction, size: 30),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          user, sound[num[1]], question[num[1]]), //sound
                    ));
              }, //audio
            ),
          ),
          Text(
            'Section3',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
          ),
          new SizedBox(
            width: 100,
            height: 100,
            child: NeumorphicFloatingActionButton(
              child: Icon(Icons.construction, size: 30),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          user, sound[num[2]], question[num[2]]), //sound
                    ));
              }, //sound3
            ),
          ),
          /*
          NeumorphicButton(
            onPressed: () {
              print("onClick");
            },
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.favorite_border,
              //color: _iconsColor(context),
            ),
          ),
          */
        ],
      ),
    );
  }
}
