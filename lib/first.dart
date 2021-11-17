import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_memo/Login/login.dart';
import 'package:music_memo/main.dart';
import 'dart:math' as math;

import 'tutorial/tuto.dart';

class FirstPage extends StatefulWidget {
  //const FirstPage({Key? key}) : super(key: key);
  FirstPage(this.user, this.isEnded1, this.isEnded2, this.isEnded3, this.num,
      this.countPage);
  String user;
  bool isEnded1, isEnded2, isEnded3;
  List countPage;
  final num;

  @override
  State<FirstPage> createState() =>
      _FirstPageState(user, isEnded1, isEnded2, isEnded3, num, countPage);
}

class _FirstPageState extends State<FirstPage> {
  _FirstPageState(
    this.user,
    this._isEnded1,
    this._isEnded2,
    this._isEnded3,
    this.num,
    this.countPage,
  );
  String user;
  //ボタンを無効にする
  bool _isEnded1;
  bool _isEnded2;
  bool _isEnded3;
  final num;
  List countPage;
  //final num = List<int>.generate(3, (i) => i + 0);
  final sound = ['ssound4', 'ssound5', 'ssound6'];
  final question = ['question4', 'question5', 'question6'];

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double devicewidth = MediaQuery.of(context).size.width;
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
                fontSize: deviceheight * 0.03,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),

          Center(
            child: Text(
              'Section1-3のボタンを押すと問題が始まります。\nSection1,2,3の順番に解いてください。\n全てのSectionを完了させてください。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: deviceheight * 0.02,
              ),
            ),
          ),
          Column(children: <Widget>[
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(
                      'testお試し',
                      style: TextStyle(
                        fontSize: deviceheight * 0.03,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    new SizedBox(
                        width: devicewidth * 0.3,
                        height: devicewidth * 0.3,
                        child: NeumorphicFloatingActionButton(
                          child: Icon(Icons.audiotrack, size: 50),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TutoPage(user, num, countPage)));
                          },
                        )),
                  ]),
                  Column(
                    children: <Widget>[
                      Text(
                        'Section 1',
                        style: TextStyle(
                          fontSize: deviceheight * 0.03,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoMono',
                          color: countPage.length > 0
                              ? Colors.green
                              : Colors.black,
                        ),
                      ),
                      new SizedBox(
                        width: devicewidth * 0.3,
                        height: devicewidth * 0.3,
                        child: NeumorphicFloatingActionButton(
                          child: Icon(
                            Icons.campaign_sharp,
                            size: 50,
                            color: countPage.length > 0
                                ? Colors.green
                                : Colors.black,
                          ),
                          onPressed: _isEnded1 //trueなら押せなくする
                              ? null
                              : () async {
                                  print('$num');
                                  _isEnded1 = true;
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                            user,
                                            sound[num[0]],
                                            question[num[0]],
                                            _isEnded1,
                                            _isEnded2,
                                            _isEnded3,
                                            num,
                                            countPage), //sound
                                      ));
                                },
                        ),
                      ),
                    ],
                  )
                ]),
            new SizedBox(
              height: deviceheight * 0.07,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Section2',
                      style: TextStyle(
                        fontSize: deviceheight * 0.03,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                        color:
                            countPage.length > 1 ? Colors.green : Colors.black,
                      ),
                    ),
                    new SizedBox(
                      width: devicewidth * 0.3,
                      height: devicewidth * 0.3,
                      child: NeumorphicFloatingActionButton(
                        child: Icon(
                          Icons.circle_notifications,
                          size: 50,
                          color: countPage.length > 1
                              ? Colors.green
                              : Colors.black,
                        ),
                        onPressed: _isEnded2
                            ? null
                            : () {
                                _isEnded2 = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                          user,
                                          sound[num[1]],
                                          question[num[1]],
                                          _isEnded1,
                                          _isEnded2,
                                          _isEnded3,
                                          num,
                                          countPage), //sound
                                    ));
                              }, //audio
                      ),
                    ),
                  ],
                ),
                Column(children: <Widget>[
                  Text(
                    'Section3',
                    style: TextStyle(
                      fontSize: deviceheight * 0.03,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                      color: countPage.length > 2 ? Colors.green : Colors.black,
                    ),
                  ),
                  new SizedBox(
                    width: devicewidth * 0.3,
                    height: devicewidth * 0.3,
                    child: NeumorphicFloatingActionButton(
                      child: Icon(
                        Icons.contactless_outlined,
                        size: 50,
                        color:
                            countPage.length > 2 ? Colors.green : Colors.black,
                      ),
                      onPressed: _isEnded3
                          ? null
                          : () {
                              _isEnded3 = true;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(
                                        user,
                                        sound[num[2]],
                                        question[num[2]],
                                        _isEnded1,
                                        _isEnded2,
                                        _isEnded3,
                                        num,
                                        countPage), //sound
                                  ));
                            }, //sound3
                    ),
                  ),
                ]),
              ],
            )
          ]),
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
