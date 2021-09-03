import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JudgePage2 extends StatefulWidget {
  JudgePage2(this.judge);
  bool judge = false;
  @override
  _JudgePageState2 createState() => _JudgePageState2(judge);
}

class _JudgePageState2 extends State<JudgePage2> {
  _JudgePageState2(this.cor);
  bool cor = false;
  // String n = '正解';
  Future<void> texttrans() async {
    print('loadはされる4444444444444444444444444444');
    print('$cor');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    texttrans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(children: <Widget>[
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      //title: Text('Aの動作の確認'),
                      title: Stack(children: <Widget>[
                        /*
                        Center(
                          child: Stack(children: <Widget>[
                            Icon(Icons.brightness_1_outlined,
                                color: Colors.red, size: 300.0),
                            Text('$n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                          ]),
                        ),*/
                        Center(
                          child: Stack(children: <Widget>[
                            Icon(Icons.remove_circle_outline,
                                color: Colors.blue, size: 300.0),
                            Text('不正解',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                          ]),
                        )
                      ]),
                    );
                  });
            },
            /*
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[300],
              width: 150,
              height: 200,
              child: Center(
                child: const Text('A'),
              ),
            ),*/
          ),
        ]),
      ]),
    );
  }
}
