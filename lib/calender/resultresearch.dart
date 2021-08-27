import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class ResultPage extends StatefulWidget {
  ResultPage(this.i); //渡したい
  String i;
  ResultPagePage createState() => ResultPagePage(i);
}

class ResultPagePage extends State<ResultPage> {
  ResultPagePage(this.param);
  String param;
  bool docid = false;
  final cor = [];
  final hu = [];
  final mu = [];

  //曜日から結果を検索する
  Future<void> ResearchResult() async {
    //collectionをuseridに変更する
    print('param$param');

    final snapshot = await FirebaseFirestore.instance
        .collection('rensyu')
        .doc(param)
        .get()
        .then((param) => {
              if (param.exists)
                {print('実行する'), docid = true}
              else
                {print('not実行'), docid = false}
            });

    if (docid == true) {
      //配列に追加
      final snepshot = await FirebaseFirestore.instance
          .collection('rensyu')
          .doc(param)
          .get();
      cor.add('${snepshot['correct']}');
      hu.add('${snepshot['正解']}');
      mu.add('${snepshot['不正解']}');

      setState(() {});
    }
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ResearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("$paramの結果"),
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            cor.isEmpty
                ? Text('データがありません')
                : SizedBox(
                    height: 150,
                    width: 150,
                    child: Neumorphic(
                      style: NeumorphicStyle(depth: -20),
                      child: Center(
                        child: Text(
                          '${cor[0]}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Georgia",
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
          ]),
        ));
  }
}
