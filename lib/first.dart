import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_memo/Login/login.dart';
import 'package:music_memo/main.dart';

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

  @override
  Widget build(BuildContext context) {
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
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(user, 'sound', 'question'), //sound
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
                      builder: (context) =>
                          MyHomePage(user, 'sound2', 'question2'), //sound
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
                      builder: (context) =>
                          MyHomePage(user, 'sound3', 'question3'), //sound
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
