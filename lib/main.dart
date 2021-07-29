import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/object.dart';

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
  List re = []; //正解か不正解か
  get child => null; //result

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
  String nameString = 'noname'; //appbar
  String nameai = 'dd';

  final dlist = []; //初期値設定問題文初期値を2個以上つけたらエラーでない
  final anslist = [];
  final ans_url = []; //ansリストのurl
  final selist = []; //選択肢のリスト
  final quelist = []; //問題のリスト
  final ans_file = []; //正解のファイル名リスト//無駄
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
    for (int i = 0; i < aiu.length; i++) {
      //quelist.add(aiu[i]);
    }
  }

  Future<void> QueExample() async {
    calcurate(queli);
  }

  Future<void> Initialized() async {
    //リストの初期化
    dlist.removeRange(0, dlist.length);
    anslist.removeRange(0, anslist.length);
    ans_url.removeRange(0, ans_url.length);
    selist.removeRange(0, selist.length);
    list.removeRange(0, list.length);
    docList.removeRange(0, docList.length); //回数分ロードするから無駄
    ans_file.removeRange(0, ans_file.length); //無駄
    ai += 1;
    _isEnabled = false;
  }

  Future<void> fetchName() async {
    Initialized(); //初期化
    print('問題格納リスト$queli');

    //関数定義
    //final snapshot = await FirebaseFirestore.instance.collection('users').get();
    //nameString = snapshot.docs.first.data()['audio']; //name要素の一番最初だけ持ってくる？

    //問題データ
    await FirebaseFirestore.instance.collection('users').get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) {
                docList.add(doc.id); //[que_1,que_2,que_3]
              },
            ),
          },
        );
    for (int i = 0; i < docList.length; i++) {
      final snepshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(docList[i])
          .get();
      String que = 'snepsqhot${snepshot['que']}';
      String ans = 'snepshota${snepshot['audio']}';
      dlist.add(que); //[フルートの音を選択]
      anslist.add(ans); //[dri_fl.mp3]
      final j = ans.length - 4;
      final uu = ans.substring(0, j); //.mp3を削除
      ans_file.add(uu);
      setState(() {});
    }

    //正解データ
    for (int i = 0; i < anslist.length; i++) {
      final audio_data = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('audio')
          .child(anslist[queli[ai]]) //lot
          .getDownloadURL();
      ans_url.add(audio_data);
    }
    await player.setUrl(ans_url[queli[ai]]); //lot

    //問題データ
    soundData(docList);
    print('documentid');
    print(docList);
    setState(() {});
  }

  //選択肢のファイルの名前取得　ドキュメントidのディレクトリのファイルを参照して、ファイルの名前を一部抽出
  Future<void> soundData(doc) async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('audio')
            .child(doc[queli[ai]]) //0の値をよくよく変更
            .listAll();
    result.items.forEach((firebase_storage.Reference ref) async {
      final ji = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .fullPath;
      print("file name-------");
      print('乱数${queli[ai]}');
      print('${doc[queli[ai]]}');
      final j = doc[queli[ai]].length;
      print(j);
      final uu = ji.substring(j + 7); //ファイル名だけ抽出
      selist.add(uu);
      if (selist.length > 3) audiodata(selist, doc);
      setState(() {});
    });
  }

  //音をランダムに配置
  final dd = <String>[];
  audiodata(aiu, eio) async {
    //遅延回避
    dd.removeRange(0, dd.length);
    var dat;
    for (int j = 0; j < aiu.length; j++) {
      int lottery = math.Random().nextInt(j + 1);
      dat = aiu[j];
      aiu[j] = aiu[lottery];
      aiu[lottery] = dat;
    }
    for (int i = 0; i < aiu.length; i++) {
      dd.add(aiu[i]);
    }
    print('dd$dd');
    urllist(aiu, eio); //aiuがリスト
    print('aiu$aiu'); //aiuリストの中でans_urlと一致するやつが正解
  }

  //音のUrl取得
  Future<void> urllist(aiu, doc) async {
    print('docdoc$doc');
    print('aiuaiu:$aiu');
    print('nagasa${aiu.length}');
    for (int i = 0; i < aiu.length; i++) {
      final audio_url = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('audio')
          .child(doc[queli[ai]]) //jとかにすべき
          .child(aiu[i])
          .getDownloadURL();
      list.add(audio_url);
      print(i);
      print('aiaiai');
      print(audio_url);
    }
    _isEnabled = true;
    setState(() {}); //描画
    await player1.setUrl(list[0]);
    await player2.setUrl(list[1]);
    await player3.setUrl(list[2]);
    await player4.setUrl(list[3]);
    //_isEnabled = true;
  }

  //stop音
  stopsound() async {
    player.stop();
    player1.stop();
    player2.stop();
    player3.stop();
    player4.stop();
  }

  int i = 0;
  final end = [];
  final result = [];
  //選択肢があっているか否か
  answer(String val) async {
    print('-----------');
    print(anslist[queli[ai]]); //urlになってるからファイル名にする
    print(val); //表示されてるのでこれとaiuで一致すれば正解みたいな感じにする
    print('66');
    if (anslist[queli[ai]] != val) {
      print('不正解');
      print(val);
      print('docList$docList'); //
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IncorPage(ans_file, queli[ai])),
      );
      result.add('不正解');
    } else {
      print('正解');
      print(i);
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CorrectPage()),
      );
      result.add('正解');
    }
    i++;
    end.add(i);
    print(i);
    print(result);
    if (i > 2) {
      final now = new DateTime.now();
      final date =
          new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      print(date);
      print(DateTime.now().day);
      //実行する

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
            builder: (context) =>
                EndPage('$now', end, dlist, result)), //param: '$date'
      );
    } else {
      fetchName();
    }
  }

  //audiocacheクラスの初期化
  //AudioCache player = AudioCache();
  AudioPlayer player = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player1 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player3 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player4 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  //AudioPlayer player5 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  //AudioPlayer player6 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    QueExample();
    fetchName();
    //getCsvData('assets/que.csv');
  }

  String _acceptedData = 'Target'; // 受け側のデータ
  bool _willAccepted = false; // Target範囲内かどうかのフラ

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
                  ), //error //問題混ぜる時は
                //RaisedButton(
                new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: FloatingActionButton(
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.volume_up),
                      heroTag: "btn1",
                      onPressed: !_isEnabled
                          ? () {
                              //print(list[lot]);
                              player1.stop();
                              player2.stop();
                              player3.stop();
                              player4.stop();
                              print(_isEnabled);
                              player.play(ans_url[0]);

                              //position: new Duration(milliseconds: 5)); //鳴った!
                            }
                          : null),
                ), //),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
                    children: <Widget>[
                      //Column(children: <Widget>[
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
                                  print('------------------pp-');
                                  print(_isEnabled);
                                }
                          //buttonを押した時の処理
                          ),
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
                                  print('dd:${dd[0]}');
                                  answer(dd[0]);
                                  print('select$_isEnabled');
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            onPrimary: Colors.white,
                          ),
                        ),
                        //child: Text('select 1')),
                      ),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
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
                            : null, //buttonを押した時の処理
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
                                    print('dd:${dd[1]}');
                                    answer(dd[1]);
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
                    children: <Widget>[
                      //Column(children: <Widget>[
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
                        }, //buttonを押した時の処理
                      ),
                      /*
                      TextButton(
                          onPressed: () {
                            stopsound();
                            print('dd:${dd[2]}');
                            answer(dd[2]);
                          },
                          child: Text('select 3')),*/
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
                                    print('dd:${dd[2]}');
                                    answer(dd[2]);
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
                    children: <Widget>[
                      //Column(children: <Widget>[

                      //ドラッグする対象
                      //Draggable(
                      //data: list.length > 2 ? '${list[3]}' : '',
                      //data: '${list}',
                      //child:
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
                          //_player.play('test5.wav');
                        }, //buttonを押した時の処理
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
                                    print('dd:${dd[3]}');
                                    answer(dd[3]);
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
                //]),
                /*
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
                    children: <Widget>[
                      Column(children: <Widget>[
                        FloatingActionButton(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.volume_up),
                          heroTag: "btn6",
                          onPressed: () {
                            print(list[4]);
                            player5.play(list[4]);
                          }, //buttonを押した時の処理
                        ),
                        TextButton(
                            onPressed: () {
                              answer(4);
                            },
                            child: Text('select 5')),
                      ]),,,
                      /*
                      Column(children: <Widget>[
                        FloatingActionButton(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.volume_up),
                          heroTag: "btn7",
                          onPressed: () {
                            print(list[5]);
                            player6.play(list[5]);
                          }, //buttonを押した時の処理
                        ),
                        TextButton(
                            onPressed: () {
                              answer(5);
                            },
                            child: Text('select 6')),
                      ]),*/
                    ]),*/
                //Stack(
                /*Stack(alignment: AlignmentDirectional.center, children: <Widget>[
                  Positioned(
                    top: 30,
                    left: 30,
                    //width: 5.0,
                    //height: 5.0,
                    child: Center(
                      child: Text('end'),
                    ),
                  ),
                ]),*/
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
                      //_isEnabled=true;
                    )
                  : Text(''),
            ),
          ),
        ],
      ),
    ); //widget
  }
}
