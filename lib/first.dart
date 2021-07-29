import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
          Row(children: <Widget>[
            Text(
              'Hi shihoさん',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono'),
            ),
          ]),
          //Center(),
          Text('楽器テスト'),
          new SizedBox(
            width: 100,
            height: 100,
            child: NeumorphicFloatingActionButton(
              child: Icon(Icons.campaign_sharp, size: 30),
              onPressed: () {},
            ),
          ),
          Text('単音メロディーテスト'),
          new SizedBox(
            width: 100,
            height: 100,
            child: NeumorphicFloatingActionButton(
              child: Icon(Icons.construction, size: 30),
              onPressed: () {},
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
