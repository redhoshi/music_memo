import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/object.dart';
import 'package:music_memo/correctend/end_page.dart';
import 'package:music_memo/first.dart';
import 'package:music_memo/group.dart';
import 'package:music_memo/login.dart';

import 'dart:math' as math;

import 'package:music_memo/correctend/next_page.dart';
import 'package:music_memo/correctend/incorrect_page.dart';

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
        home: const MyHomePage()); //home: const MyHomePage
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//終了画面
/*
class EndPage extends StatelessWidget {
  EndPage(this.name, this.e, this.text, this.re, this.val);
  String name;
  List e = []; //問題番号
  List text = []; //問題のテキスト
  List re = []; //正解か不正解かaiu
  int val = 0;
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: const Border(
                left: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                right: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                top: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                bottom: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '$val',
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
}*/

class _MyHomePageState extends State<MyHomePage> {
  //ここで変数とか関数を定義

  //問題と正解データを格納するリスト
  final dlist = []; //初期値設定問題文初期値を2個以上つけたらエラーでない
  final ans_url = []; //ansリストのurl
  final selist = []; //選択肢のリスト
  final quelist = []; //問題のリスト
  final ans_file = []; //dri_tp,画像データのファイル名指定
  final countslist = []; //問題データ格納用
  int ai = -1;

  //選択肢データを格納するリスト
  final list = <String>[]; //audioファイルリスト
  final queli = List<int>.generate(6, (i) => i + 0);
  List docList = []; //ドキュメントidを取ってくる
  final docuList = new List.generate(10, (index) => ''); //可変長？
  bool _isEnabled = false; //onbuttonを押させない

  //ログデータを取得するためのリスト
  //回答時間
  Stopwatch time_ans = Stopwatch();

  //音源データを聞いている時間
  Stopwatch time_lis1 = Stopwatch();
  Stopwatch time_lis2 = Stopwatch();
  Stopwatch time_lis3 = Stopwatch();
  Stopwatch time_lis4 = Stopwatch();
  Stopwatch time_lis5 = Stopwatch();

  //音源ボタンを押した回数
  int count1 = 0; //音源データをタップした回数
  int count2 = 0;
  int count3 = 0;
  int count4 = 0;
  int count5 = 0;

  //いつどのボタンを押したかのタイムスタンプ
  final List<Map<String, dynamic>> serviceTime = [];

  //答えの画面で表示するリスト
  int value = 0; //得点

  //docListのカウント
  int counta = 0;
  //順位ソートに用いる
  int sort = 0;
  //sort初期化を防ぐ
  int counts = 0;
  //test
  final ada = [0, 0, 0, 0];
  final adb = [];

  calcurate(aiu) async {
    var dat;
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

    //ストップウォッチの初期化
    time_lis1.reset();
    time_lis2.reset();
    time_lis3.reset();
    time_lis4.reset();
    time_lis5.reset();
    time_ans.reset(); //回答時間の初期化

    //ボタンカウンタの初期化
    count1 = 0;
    count2 = 0;
    count3 = 0;
    count4 = 0;
    count5 = 0;

    //sort
    counts = 0;
  }

  //問題データ(文)と正解データ---1回読み込めば良いデータ
  Future<void> AnswerName() async {
    //問題のリスト
    //**変更：usersからquestion */
    int i = 0;
    ada[2] = 3;

    await FirebaseFirestore.instance.collection('question').get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) async {
                docList.add(doc.id); //[que_1,que_2,que_3]
              },
            ),
          },
        );
    counta = (docList.length / 2).toInt(); //問題レベル中間からスタート
    counts = counta + sort; //3
    print('counta$sort');
    print('doclist--1$counts');
    //docListがawaitするからそれ以降の中身がfetchNameに渡されない
    soundData(docList); //que_1のみ
    print('doclist--2$docList');
    //フィールドを参照
    for (int i = 0; i < docList.length; i++) {
      ///再度検討
      final snepshot = await FirebaseFirestore.instance
          .collection('question')
          .doc(docList[i])
          .get();
      String que = '${snepshot['que']}'; //問題文
      String ans = '${snepshot['audio']}'; //正解のファイル名

      print('que$que');
      print('ans$ans');
      //正解データのURL取得
      final audio_data = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('sound')
          .child(docList[i])
          .child(ans)
          .getDownloadURL();
      ans_url.add(audio_data); //正解のurlを選択肢のところと同じところから取ってくる
      print('count----$i');
      //問題文リスト作成
      dlist.add(que); //[フルートの音を選択]
      print('dlist$dlist');

      //画像参照用のファイル名取得
      final j = ans.length - 4; //ファイル名取得
      final uu = ans.substring(0, j); //.mp3を削除
      ans_file.add(uu); //ans_fileリストに格納
      setState(() {});
    }
    //問題文リストから難易度別のリストに並べた
    countslist.add(dlist[counts]); //countsのlistを提示
    print('countlist$countslist');
    print('setstateato$docList'); //[que1,que2]
    SoundSet(ans_url[counts]); //queli[aio]
  }

  Future<void> SoundSet(ans) async {
    await player1.setUrl(ans);
  }

  //試作用
  Future<void> PassDoc() async {
    ada[1] = 1;
    adb.add(1);
  }

  Future<void> fetchName() async {
    Initialized(); //初期化
    print('問題格納リスト$queli'); //機能しない
    AnswerName();
    setState(() {});
  }

  //選択肢のファイルの名前取得　ドキュメントidのディレクトリのファイルを参照して、ファイルの名前を一部抽出
  Future<void> soundData(doc) async {
    //選択肢ファイルのファイル名取得
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('sound')
        .child(doc[counts])
        .listAll(); //que_1の中のファイル名を返す
    result.items.forEach((firebase_storage.Reference ref) async {
      final ji = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .fullPath; //パスを取得

      final uu = ji.substring(doc[counts].length + 7); //ファイル名だけ抽出
      selist.add(uu); //usse_org.mp3
      if (selist.length > 3) audiodata(selist, doc);
      setState(() {});
    });
    // print('${time_ans.elapsed}');
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
          .child('sound') /*audio->sound */
          .child(doc[counts]) //que_1
          .child(aiu[i]) //dri_tp
          .getDownloadURL();
      list.add(audio_url); //listに格納する
    }
    print('urllist$list');
    for (int i = 0; i < 4; i++) {
      SetUrl(i);
    }
/*
    await player1.setUrl(list[0]); //awaitせずにasyncで非同期処理にすると早くなる。
    await player2.setUrl(list[1]);
    await player3.setUrl(list[2]);
    await player4.setUrl(list[3]);*/
    _isEnabled = true;
    time_ans.start();
    setState(() {}); //描画
  }

  //asyncで早くなる
  Future<void> SetUrl(n) async {
    int i = 0;
    switch (n) {
      case 0:
        await player1.setUrl(list[0]);
        i++;
        break;
      case 1:
        await player2.setUrl(list[1]);
        i++;
        break;
      case 2:
        await player3.setUrl(list[2]);
        i++;
        break;
      case 3:
        await player4.setUrl(list[3]);
        i++;
        break;
    }
    print(i);
  }

  //stop音
  stopsound() async {
    player1.stop();
    player2.stop();
    player3.stop();
    player4.stop();
    player5.stop();
  }

  //ストップウォッチ回答時間
  void StopTime() {
    time_ans.stop();
    print('回答時間${time_ans.elapsed}');
  }

  int i = 0; //問題番号カウント
  final end = []; //問題
  final result = []; //正解・不正解の結果

  //選択肢があっているか否か
  answer(String val) async {
    StopTime();
    if (ans_url[counts] != val) {
      print('不正解');
      value -= 10;
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                IncorPage(ans_file, counts, ans_url, val)), //ファイル名と引数
      );
      result.add('不正解');
      sort--;
    } else {
      print('正解');
      value += 10;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CorrectPage()),
      );
      result.add('正解');
      sort++;
    }

    final now = new DateTime.now();
    final date =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    print(date);
    print(DateTime.now().day);
    print('result${result[0]}');
    print(i);
    //ログデータの書き込み
    await FirebaseFirestore.instance
        .collection('results') // コレクションID--->名前入力でも良いかもね
        .doc('$now') // ここは空欄だと自動でIDが付く
        .set({
      'que': '${docList[i]}',
      'ans': '${result[i]}',
      'btn': ['$count1', '$count2', '$count2', '$count3', '$count4'],
      'soundtime': [
        '${time_lis1.elapsed}',
        '${time_lis2.elapsed}',
        '${time_lis3.elapsed}',
        '${time_lis4.elapsed}',
        '${time_lis5.elapsed}'
      ],
      'time_ans': '${time_ans.elapsed}',
    });
    i++;
    end.add(i);
    if (i > 2) {
      print('value$value');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EndPage('$now', end, countslist, result, value)),
      );
    } else {
      //soundData();ここでdocListを取れば良いと思う
      fetchName(); //ここで呼んでる
    }
  }

  //audiocacheクラスの初期化
  AudioPlayer player1 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player3 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player4 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player5 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //playしている時間
  Future<void> PlayTime() async {
    //問題データのplayorstop
    player1.onPlayerStateChanged.listen((event) {
      if (player1.state == PlayerState.PLAYING) {
        time_lis1.start();
        print('player1:start${time_lis1.elapsed}');
      }
      if (player1.state == PlayerState.STOPPED ||
          player1.state == PlayerState.COMPLETED) {
        time_lis1.stop();
        print('player1:stop${time_lis1.elapsed}');
      }
      print('Event:player1:$event');
    });
    //player1がplyaing,stoppedorcomplete
    player2.onPlayerStateChanged.listen((event) {
      if (player2.state == PlayerState.PLAYING) {
        time_lis2.start();
        print('player2:start${time_lis2.elapsed}');
      }
      if (player2.state == PlayerState.STOPPED ||
          player2.state == PlayerState.COMPLETED) {
        time_lis2.stop();
        print('player2:stop:${time_lis2.elapsed}');
      }
      print('Event2$event');
    });
    //player1がplyaing,stoppedorcomplete
    player3.onPlayerStateChanged.listen((event) {
      if (player3.state == PlayerState.PLAYING) {
        time_lis3.start();
        print('player3:start${time_lis3.elapsed}');
      }
      if (player3.state == PlayerState.STOPPED ||
          player3.state == PlayerState.COMPLETED) {
        time_lis3.stop();
        print('player3:stop:${time_lis3.elapsed}');
      }
      print('Event1$event');
    });
    player4.onPlayerStateChanged.listen((event) {
      if (player4.state == PlayerState.PLAYING) {
        time_lis4.start();
        print('player4:start:${time_lis4.elapsed}');
      }
      if (player4.state == PlayerState.STOPPED ||
          player4.state == PlayerState.COMPLETED) {
        time_lis4.stop();
        print('player4:stop:${time_lis4.elapsed}');
      }
      print('Event1$event');
    });
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    QueExample();
    Initialized();
    //追加
    PassDoc();
    fetchName();
    PlayTime();
  }

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
                      dlist.length > 5 ? dlist[counts] : '', //これが一番遅いかな
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: FloatingActionButton(
                    onPressed: !_isEnabled
                        ? null
                        : () {
                            final now = new DateTime.now(); //いつボタン押したか。
                            serviceTime.add({'btn1': '$now'});
                            count1++; //何回押したか
                            player1.stop();
                            player2.stop();
                            player3.stop();
                            player4.stop();
                            print(serviceTime);
                            print(_isEnabled);
                            player1.play(ans_url[counts]);
                          },
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.volume_up),
                    heroTag: "btn1",
                  ),
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
                            ? () {
                                print(list[0]);
                                player1.stop();
                                player3.stop();
                                player4.stop();
                                player5.stop();
                                //time_lis.start();
                                //print('timestart${time_lis.elapsed}');
                                player2.play(list[0]);
                                print(_isEnabled);
                                count2++;
                              }
                            : null,
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
                                player1.stop();
                                player2.stop();
                                player4.stop();
                                player5.stop();
                                player3.play(list[1]);
                                count3++;
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
                          player1.stop();
                          player2.stop();
                          player3.stop();
                          player4.stop();
                          player4.play(list[2]);
                          count4++;
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
                          player1.stop();
                          player2.stop();
                          player3.stop();
                          player4.stop();
                          player5.play(list[3]);
                          count5++;
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
            child: !_isEnabled
                ? Container(
                    color: Color(0xFFE4E6F1),
                  )
                : Text(''),
          ),
          Positioned(
            top: 200,
            left: 160,
            child: DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Horizon',
                  color: Colors.black,
                  fontWeight: FontWeight.w100),
              child: !_isEnabled
                  ? AnimatedTextKit(
                      animatedTexts: [FadeAnimatedText('Loading....')],
                    )
                  : Text(''),
            ),
          ),
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
