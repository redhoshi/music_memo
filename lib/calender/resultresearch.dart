import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("$paramの結果"),
      ),
      body: Column(children: <Widget>[
        Text('aiu'),
      ]),
    );
  }
}
