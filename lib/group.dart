import 'package:flutter/material.dart';

//何か一つの楽器の音をだしてこれが何の音かは言わずにどこの楽器群に属すと思うか判別しよう！
//そもそもどの楽器群がどんな音っていう前提知識が必要である。それを学習させるコンテンツを作る必要があるね。チュートリアル的な何か

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

String _acceptedData = 'Target'; // 受け側のデータ
bool _willAccepted = false; // Target範囲内かどうかのフラ

class _GroupPageState extends State<GroupPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FirstPage'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(children: <Widget>[
              Draggable(
                data: 'red',
                child: FloatingActionButton(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.volume_up),
                  heroTag: "btn5",
                  onPressed: () {},
                ),
                feedback: FloatingActionButton(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.volume_up),
                  heroTag: "btn5",
                  onPressed: () {},
                ),
              ),
              Row(
                children: [
                  DragTarget(
                    //左上ドラッグする箇所
                    builder: (context, accepted, rejected) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _willAccepted ? Colors.orange : Colors.grey,
                            width: _willAccepted ? 5 : 1,
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                            child: Text('${_acceptedData}1',
                                style: TextStyle(fontSize: 50))),
                      );
                    },
                    onWillAccept: (data) {
                      print('onWillAccept - $data');
                      print(_willAccepted);
                      // ドラッグ操作を受け入れる場合はここでtrueを返す
                      return true;
                      print(_willAccepted);
                    }, // DragTargetにドラッグされた時に呼ばれる
                    onAccept: (data) {
                      print('onAccept - $data');
                    }, // DragTarget の範囲から離れた時に呼ばれる
                    onLeave: (data) {
                      print('onLeave - $data');
                    },
                  ),
                  new SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  DragTarget(
                    //左上ドラッグする箇所
                    builder: (context, accepted, rejected) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _willAccepted ? Colors.orange : Colors.grey,
                            width: _willAccepted ? 5 : 1,
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                            child: Text('${_acceptedData}2',
                                style: TextStyle(fontSize: 50))),
                      );
                    },
                    onWillAccept: (data) {
                      print('onWillAccept - $data');
                      // ドラッグ操作を受け入れる場合はここでtrueを返す
                      return true;
                    }, // DragTargetにドラッグされた時に呼ばれる
                    onAccept: (data) {
                      print('onAccept - $data');
                    }, // DragTarget の範囲から離れた時に呼ばれる
                    onLeave: (data) {
                      print('onLeave - $data');
                    },
                  ),
                ],
              ),
              new SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  DragTarget(
                    //左上ドラッグする箇所
                    builder: (context, accepted, rejected) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _willAccepted ? Colors.orange : Colors.grey,
                            width: _willAccepted ? 5 : 1,
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                            child: Text(_acceptedData,
                                style: TextStyle(fontSize: 50))),
                      );
                    },
                    onWillAccept: (data) {
                      print('onWillAccept - $data');
                      // ドラッグ操作を受け入れる場合はここでtrueを返す
                      return true;
                    }, // DragTargetにドラッグされた時に呼ばれる
                    onAccept: (data) {
                      print('onAccept - $data');
                    }, // DragTarget の範囲から離れた時に呼ばれる
                    onLeave: (data) {
                      print('onLeave - $data');
                    },
                  ),
                  new SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  DragTarget(
                    //左上ドラッグする箇所
                    builder: (context, accepted, rejected) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _willAccepted ? Colors.orange : Colors.grey,
                            width: _willAccepted ? 5 : 1,
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                            child: Text(_acceptedData,
                                style: TextStyle(fontSize: 50))),
                      );
                    },
                    onWillAccept: (data) {
                      print('onWillAccept - $data');
                      // ドラッグ操作を受け入れる場合はここでtrueを返す
                      return true;
                    }, // DragTargetにドラッグされた時に呼ばれる
                    onAccept: (data) {
                      print('onAccept - $data');
                    }, // DragTarget の範囲から離れた時に呼ばれる
                    onLeave: (data) {
                      print('onLeave - $data');
                    },
                  ),
                ],
              ),
            ]),
          ],
        ));
  }
}
