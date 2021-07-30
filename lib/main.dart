import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/object.dart';
import 'package:music_memo/first.dart';
import 'package:music_memo/login.dart';

import 'dart:math' as math;

import 'package:music_memo/next_page.dart';
import 'package:music_memo/incorrect_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//firebasestorage初期化
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const MyHomePage()); //MyHomePage67
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//終了画面
class EndPage extends StatelessWidget {
  EndPage(this.name, this.e, this.text, this.re);
  String name;
  List e = []; //問題番号
  List text = []; //問題のテキスト
  List re = []; //正解か不正解かaiu
  get child => null; //result

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildsss
    return Scaffold(
      appBar: AppBar(
        title: Text('終了画面'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('【$name】の結果'),
          Table(
            border: TableBorder.all(),
            children: [
              for (int i = 0; i < e.length; i++)
                TableRow(children: [
                  Text('第${e[i]}問'),
                  Text('${text[i]}'),
                  Text('${re[i]}')
                ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  //ここで変数とか関数を定義

  final dlist = []; //初期値設定問題文初期値を2個以上つけたらエラーでない
  final ans_url = []; //ansリストのurl
  final selist = []; //選択肢のリスト
  final quelist = []; //問題のリスト
  final ans_file = []; //dri_tp,画像データのファイル名指定
  int ai = -1;

  final list = <String>[]; //audioファイルリスト
  final queli = List<int>.generate(3, (i) => i + 0);
  List docList = []; //ドキュメントidを取ってくる
  bool _isEnabled = false; //onbuttonを押させない

  calcurate(aiu) {
    var dat; //乱数作成
    for (int j = 0; j < aiu.length; j++) {
      int lottery = math.Random().nextInt(j + 1);
      dat = aiu[j];
      aiu[j] = aiu[lottery];
      aiu[lottery] = dat;
    }
  }

  Future<void> QueExample() async {
    calcurate(queli); //[0,1,2]をランダムにする
  }

//リストの初期化(繊維ごとに初期化)
  Future<void> Initialized() async {
    dlist.removeRange(0, dlist.length);
    ans_url.removeRange(0, ans_url.length);
    selist.removeRange(0, selist.length);
    list.removeRange(0, list.length);
    docList.removeRange(0, docList.length); //回数分ロードするから無駄
    ans_file.removeRange(0, ans_file.length); //無駄
    ai += 1;
    _isEnabled = false;
  }

  //問題データ(文)と正解データ
  AnswerName() async {
    //問題のリスト
    await FirebaseFirestore.instance.collection('users').get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) async {
                docList.add(doc.id); //[que_1,que_2,que_3]
                final snepshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(doc.id)
                    .get();
              },
            ),
          },
        );
    //フィールドを参照
    for (int i = 0; i < docList.length; i++) {
      ///再度検討
      final snepshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(docList[i])
          .get();
      String que = '${snepshot['que']}'; //問題文
      String ans = '${snepshot['audio']}'; //正解のファイル名

      //正解データのURL取得
      final audio_data = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('audio')
          .child(docList[i])
          .child(ans)
          .getDownloadURL();
      ans_url.add(audio_data); //正解のurlを選択肢のところと同じところから取ってくる

      //問題文リスト作成
      dlist.add(que); //[フルートの音を選択]

      //画像参照用のファイル名取得
      final j = ans.length - 4; //ファイル名取得
      final uu = ans.substring(0, j); //.mp3を削除
      ans_file.add(uu); //ans_fileリストに格納
      setState(() {});
      //lot
    }
    await player.setUrl(ans_url[queli[ai]]);
    //問題データ
    soundData(docList);
  }

  Future<void> fetchName() async {
    Initialized(); //初期化
    print('問題格納リスト$queli');
    AnswerName();
    setState(() {});
  }

  //選択肢のファイルの名前取得　ドキュメントidのディレクトリのファイルを参照して、ファイルの名前を一部抽出
  Future<void> soundData(doc) async {
    //選択肢ファイルのファイル名取得
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('audio')
        .child(doc[queli[ai]])
        .listAll();
    result.items.forEach((firebase_storage.Reference ref) async {
      final ji = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .fullPath;
      final uu = ji.substring(doc[queli[ai]].length + 7); //ファイル名だけ抽出
      selist.add(uu);
      if (selist.length > 3) audiodata(selist, doc);
      setState(() {});
    });
  }

  //音をランダムに配置
  audiodata(aiu, eio) async {
    calcurate(aiu);
    urllist(aiu, eio); //aiuがリスト
    print('aiu$aiu'); //aiuリストの中でans_urlと一致するやつが正解
  }

  //音のUrl取得
  Future<void> urllist(aiu, doc) async {
    for (int i = 0; i < aiu.length; i++) {
      final audio_url = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('audio')
          .child(doc[queli[ai]]) //que_1
          .child(aiu[i]) //dri_tp
          .getDownloadURL();
      list.add(audio_url); //listに格納する
    }
    //_isEnabled = true;
    //setState(() {}); //描画
    await player1.setUrl(list[0]);
    await player2.setUrl(list[1]);
    await player3.setUrl(list[2]);
    await player4.setUrl(list[3]);
    _isEnabled = true;
    setState(() {}); //描画
  }

  //stop音
  stopsound() async {
    player.stop();
    player1.stop();
    player2.stop();
    player3.stop();
    player4.stop();
  }

  int i = 0; //問題番号カウント
  final end = []; //問題
  final result = []; //正解・不正解の結果

  //選択肢があっているか否か
  answer(String val) async {
    if (ans_url[queli[ai]] != val) {
      print('不正解');
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IncorPage(ans_file, queli[ai])), //ファイル名と引数
      );
      result.add('不正解');
    } else {
      print('正解');
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CorrectPage()),
      );
      result.add('正解');
    }
    i++;
    end.add(i);
    if (i > 2) {
      final now = new DateTime.now();
      final date =
          new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      print(date);
      print(DateTime.now().day);

      //結果をfirebasecloudfirestoreに上げる
      /*
      for (int j = 0; j < result.length; j++) {
        final now = DateTime.now();
        await FirebaseFirestore.instance
            .collection('results') // コレクションID--->名前入力でも良いかもね
            .doc('$now') // ここは空欄だと自動でIDが付く
            .set({
          'ans': '${result[j]}',
          'que': '${docList[j]}',
        });
      }*/

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EndPage('$now', end, dlist, result)),
      );
    } else {
      fetchName();
    }
  }

  //audiocacheクラスの初期化
  AudioPlayer player = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player1 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player3 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player4 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    QueExample();
    fetchName();
  }

  //String _acceptedData = 'Target'; // 受け側のデータ
  //bool _willAccepted = false; // Target範囲内かどうかのフラ

  @override
  Widget build(BuildContext context) {
    //buildの中に変数書くの良くない
    return Scaffold(
      appBar: AppBar(
        title: Text('第${i + 1}問'),
      ),
      body: Stack(
        children: [
          Column(
              //縦
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (dlist.length > 2)
                  new SizedBox(
                    width: 500.0,
                    height: 20.0,
                    child: Text(
                      dlist[queli[ai]],
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: FloatingActionButton(
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.volume_up),
                      heroTag: "btn1",
                      onPressed: !_isEnabled
                          ? null
                          : () {
                              player1.stop();
                              player2.stop();
                              player3.stop();
                              player4.stop();
                              print(_isEnabled);
                              player.play(ans_url[queli[ai]]); //change
                            }),
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.volume_up),
                          heroTag: "btn2",
                          onPressed: _isEnabled
                              ? null
                              : () {
                                  print(list[0]);
                                  player.stop();
                                  player2.stop();
                                  player3.stop();
                                  player4.stop();
                                  player1.play(list[0]);
                                  print(_isEnabled);
                                }),
                      new SizedBox(
                        height: 50,
                        width: 230,
                        child: ElevatedButton(
                          child: ans_url.length > 2
                              ? Text('select1')
                              : Text('loading'),
                          onPressed: !_isEnabled
                              ? null
                              : () {
                                  shape:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  );
                                  stopsound();
                                  answer(list[0]); //urlを返す
                                  print('select$_isEnabled');
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.volume_up),
                        heroTag: "btn3",
                        onPressed: ans_url.length > 2
                            ? () {
                                print("pre2"); //音を鳴らす
                                print(list[1]);
                                player.stop();
                                player1.stop();
                                player3.stop();
                                player4.stop();
                                player2.play(list[1]);
                              }
                            : null,
                      ),
                      new SizedBox(
                        height: 50,
                        width: 230,
                        child: ElevatedButton(
                            onPressed: ans_url.length > 2
                                ? () {
                                    shape:
                                    OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    );
                                    stopsound();
                                    answer(list[1]);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              onPrimary: Colors.white,
                            ),
                            child: ans_url.length > 2
                                ? Text('select 2')
                                : Text('loading')),
                      ),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.volume_up),
                        heroTag: "btn4",
                        onPressed: () {
                          print(list[2]);
                          player.stop();
                          player1.stop();
                          player2.stop();
                          player4.stop();
                          player3.play(list[2]);
                        },
                      ),
                      new SizedBox(
                        height: 50,
                        width: 230,
                        child: ElevatedButton(
                            onPressed: !_isEnabled
                                ? null
                                : () {
                                    shape:
                                    OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    );
                                    stopsound();
                                    answer(list[2]);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              onPrimary: Colors.white,
                            ),
                            child: ans_url.length > 2
                                ? Text('select 3')
                                : Text('loading')),
                      ),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.volume_up),
                        heroTag: "btn5",
                        onPressed: () {
                          print(list[3]);
                          print(list);
                          player.stop();
                          player1.stop();
                          player2.stop();
                          player3.stop();
                          player4.play(list[3]);
                        },
                      ),
                      /*feedback: FloatingActionButton(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.volume_up),
                          heroTag: "btn5",
                          onPressed: () {},
                        ),
                      ),*/

                      /*DragTarget(
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
                      ),*/
                      //kesitayo
                      new SizedBox(
                        height: 50,
                        width: 230,
                        child: ElevatedButton(
                            onPressed: !_isEnabled
                                ? null
                                : () {
                                    shape:
                                    OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    );
                                    stopsound();
                                    answer(list[3]);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              onPrimary: Colors.white,
                            ),
                            child: !_isEnabled
                                ? Text('loading')
                                : Text('select 4')),
                      ),
                    ]),
              ]),
          Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: !_isEnabled
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      strokeWidth: 8.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : Text(''),
            ),
          ),
        ],
      ),
    );
  }
}
