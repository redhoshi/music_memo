import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/object.dart';
import 'package:music_memo/Login/login.dart';
import 'package:music_memo/Login/test.dart';
import 'package:music_memo/correctend/end_page.dart';
import 'package:music_memo/slide/slide.dart';
import 'dart:math' as math;
import 'package:music_memo/wave/wave.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const LoginPage()); //home: const MyHomePage
  }
}

class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key? key}) : super(key: key);
  MyHomePage(this.user, this.sound, this.question, this.isended1, this.isended2,
      this.isended3, this.num, this.countPage);
  String user, sound, question;
  bool isended1, isended2, isended3;
  List countPage;
  final num;

  @override
  State<MyHomePage> createState() => _MyHomePageState(
      user, sound, question, isended1, isended2, isended3, num, countPage);
}

class _MyHomePageState extends State<MyHomePage> {
  //ここで変数とか関数を定義
  _MyHomePageState(this.user, this.sound, this.question, this._isEnded1,
      this._isEnded2, this._isEnded3, this.num, this.countPage);
  String user, sound, question;
  bool _isEnded1, _isEnded2, _isEnded3;
  List countPage; //3つ終わったら終了
  //問題と正解データを格納するリスト
  final dlist = []; //初期値設定問題文初期値を2個以上つけたらエラーでない
  final ans_url = []; //ansリストのurl
  final ansAudioUrlList = []; //変更した問題音urlリスト
  final ansAudioUrl = [];
  final selist = []; //選択肢のリスト
  final quelist = []; //問題のリスト
  final ans_file = []; //dri_tp,画像データのファイル名指定
  final countslist = []; //問題データ格納用
  final num; //section3つの順番
  int ai = -1;

  //選択肢データを格納するリスト
  final list = <String>[]; //audioファイルリスト
  //問題数を入力
  final queli = List<int>.generate(10, (i) => i + 0);
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
  //resound用
  Stopwatch retime1 = Stopwatch();
  Stopwatch retime2 = Stopwatch();
  Stopwatch retime3 = Stopwatch();
  Stopwatch retime4 = Stopwatch();
  Stopwatch retime5 = Stopwatch();

  //問題提示時に音源ボタンを押した回数
  int count1 = 0;
  int count2 = 0;
  int count3 = 0;
  int count4 = 0;
  int count5 = 0;
  //復習の時に音源ボタンを押した回数
  int out1 = 0;
  int out2 = 0;
  int out3 = 0;
  int out4 = 0;
  int out5 = 0;
  //正解だと思ったボタン
  int ansuser = 0;
  //soundとresound分けるよう
  Duration tsound1 = new Duration(hours: 0, minutes: 0, seconds: 0);
  Duration tsound2 = new Duration(hours: 0, minutes: 0, seconds: 0);
  Duration tsound3 = new Duration(hours: 0, minutes: 0, seconds: 0);
  Duration tsound4 = new Duration(hours: 0, minutes: 0, seconds: 0);
  Duration tsound5 = new Duration(hours: 0, minutes: 0, seconds: 0);

  //いつどのボタンを押したかのタイムスタンプ
  final List<Map<String, dynamic>> serviceTime = [];

  //答えの画面で表示するリスト
  int value = 0;
  //docListのカウント
  int counta = 0;
  //順位ソートに用いる
  int sort = 0;
  //ページ番号
  int _page = 0;
  //curpertino
  bool okBtn = false;

/*
  final double _currentSliderValue1 = 50,
      _currentSliderValue3 = 50,
      _currentSliderValue2 = 50;*/

  //slider初期値
  final slider = [50.0, 50.0, 50.0, 50.0];
  //user値
  List slidernum = [50],
      slidernum2 = [50],
      slidernum3 = [50],
      slidernum4 = [50];
  final facesheet = [];

  //showdialog用のbool
  bool show = false;
  bool _diaEnabled = false; //onbuttonしたらtrue

  final ansjudge = []; //最初から実行

  calcurate(aiu) async {
    var dat;
    for (int j = 0; j < aiu.length; j++) {
      int lottery = math.Random().nextInt(j + 1);
      dat = aiu[j];
      aiu[j] = aiu[lottery];
      aiu[lottery] = dat;
    }
  }

  Future<void> queExample() async {
    calcurate(queli); //[0,1,2]をランダムにする
  }

  //End画面への遷移
  Future<void> passend() async {
    // print('user$user,end$end,countslist:$countslist,result$result,value$value');
    if (_page == 9) firewrite();
    _page > 9
        ? Navigator.push(
            //push→pop

            context,
            MaterialPageRoute(
                builder: (context) => EndPage(
                    '$user',
                    end,
                    countslist,
                    result,
                    value,
                    _isEnded1,
                    _isEnded2,
                    _isEnded3,
                    num,
                    countPage))) //nowに名前を入れる
        : reload();
  }

  //リロード
  Future<void> reload() async {
    i++;
    print('-----------ほかほか$result');
    fetchName();
    //counts++;
  }

//リストの初期化(繊維ごとに初期化)
  Future<void> initialized() async {
    //dlist.removeRange(0, dlist.length);
    //ans_url.removeRange(0, ans_url.length);
    selist.removeRange(0, selist.length);
    list.removeRange(0, list.length);
    //docList.removeRange(0, docList.length); //回数分ロードするから無駄
    //ans_file.removeRange(0, ans_file.length); //無駄
    ansjudge.removeRange(0, ansjudge.length); //正解・不正解リストの初期化
    ai += 1;
    sort -= 1;
    _isEnabled = false;
    _diaEnabled = false;
    okBtn = false;

    //ストップウォッチの初期化
    time_lis1.reset();
    time_lis2.reset();
    time_lis3.reset();
    time_lis4.reset();
    time_lis5.reset();
    time_ans.reset();

    //カウンタの初期化
    count1 = 0;
    count2 = 0;
    count3 = 0;
    count4 = 0;
    count5 = 0;

    //カウンタの初期化
    out1 = 0;
    out2 = 0;
    out3 = 0;
    out4 = 0;
    out5 = 0;
    //ボタンのタイムスタンプの初期化
    serviceTime.removeRange(0, serviceTime.length);
    //slider初期化
    slidernum = [50];
    slidernum2 = [50];
    slidernum3 = [50];
    slidernum4 = [50];
  }

  //問題データ(文)と正解データ---1回読み込めば良いデータ
  Future<void> answerName() async {
    int i = 0;
    await FirebaseFirestore.instance.collection('$question').get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) async {
                docList.add(doc.id); //[que_1,que_2,que_3]
              },
            ),
          },
        );
    calcurate(docList);
    print('ドックりすと$docList');
    //docListがawaitするからそれ以降の中身がfetchNameに渡されない
    soundData(docList); //que_1のみ
    //フィールドを参照
    for (int i = 0; i < docList.length; i++) {
      final snepshot = await FirebaseFirestore.instance
          .collection('$question')
          .doc(docList[i])
          .get();
      //calcurate(docList); //問題をランダム化
      //soundData(docList);

      String que = '${snepshot['que']}'; //問題文
      String ans = '${snepshot['audio']}'; //正解のファイル名
      String ansaudio = '${snepshot['ansaudio']}'; //正解のファイル名
      ansAudioUrlList.add(ansaudio);
      //違うメロディーの問題音url
      final audio_ = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('toisound')
          .child(ansaudio)
          .getDownloadURL();
      ansAudioUrl.add(audio_);
      //正解データのURL取得answer関数で使用
      final audio_data = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('$sound')
          .child(docList[i])
          .child(ans)
          .getDownloadURL();
      ans_url.add(audio_data); //正解のurlを選択肢のところと同じところから取ってくる

      //print('ans_url---$ans_url'); //3個
      dlist.add(que); //[フルートの音を選択]

      //画像参照用のファイル名取得
      final j = ans.length - 4; //ファイル名取得
      final uu = ans.substring(0, j); //.mp3を削除
      ans_file.add(uu); //ans_fileリストに格納
      setState(() {});
    }
    countslist.add(dlist[counta]); //countsのlistを提示
    soundSet(ansAudioUrl[counta]); //ans_url[counta]
  }

  //2回目以降にsoundDataを呼び出す関数
  Future<void> endlist(docu) async {
    final snepshot = await FirebaseFirestore.instance
        .collection('$question')
        .doc(docu)
        .get();
    String que = '${snepshot['que']}'; //問題文
    dlist.add(que);
    countslist.add(dlist[counta]);
  }

  Future<void> soundSet(ans) async {
    await player1.setUrl(ans);
  }

  Future<void> fetchName() async {
    initialized(); //初期化
    // print('問題格納リスト$queli'); //機能しない
    counta < 1 ? answerName() : new SizedBox();
    counta > 0 ? soundData(docList) : new SizedBox();
    setState(() {});
  }

  //選択肢のファイルの名前取得　ドキュメントidのディレクトリのファイルを参照して、ファイルの名前を一部抽出
  Future<void> soundData(doc) async {
    counta > 0 ? endlist(doc[counta]) : new SizedBox();
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('$sound')
        .child(doc[counta])
        .listAll(); //que_1の中のファイル名を返す
    result.items.forEach((firebase_storage.Reference ref) async {
      final ji = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .fullPath; //パスを取得
      //print('どくどく${doc[counta]},$ji');
      final uu = ji.substring(doc[counta].length + 8); //ファイル名だけ抽出
      selist.add(uu); //usse_org.mp3
      if (selist.length > 3) audiodata(selist, doc);
      setState(() {});
    });
  }

  //音をランダムに配置
  audiodata(aiu, eio) async {
    calcurate(aiu);
    urllist(aiu, eio); //aiuがリスト
  }

  //音のUrl取得
  Future<void> urllist(aiu, doc) async {
    //print('ドックカウンタ${doc[counta]},${aiu}');
    for (int j = 0; j < aiu.length; j++) {
      final audio_url = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('$sound') /*audio->sound */
          .child(doc[counta]) //que_1
          .child(aiu[j]) //dri_tp
          .getDownloadURL();
      list.add(audio_url); //listに格納する
    }
    //  print('urllist$list');
    for (int i = 0; i < 4; i++) {
      SetUrl(i);
    }
    passans(list);
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
  void stopTime() {
    time_ans.stop();
    print('回答時間${time_ans.elapsed}');
  }

  int i = 0; //問題番号カウント
  final end = []; //問題
  final result = []; //正解・不正解の結果

  Future<void> passans(final list) async {
    print('何回実行か${ans_url.length}');
    deteans(list);
    setState(() {});
  }

  //soundtimeとresoundtimeを分ける
  Future<void> divsound() async {
    tsound1 = time_lis1.elapsed;
    tsound2 = time_lis2.elapsed;
    tsound3 = time_lis3.elapsed;
    tsound4 = time_lis4.elapsed;
    tsound5 = time_lis5.elapsed;
    setState(() {});
  }

//正解不正解のicon表示用のlist取得
  deteans(final val) {
    //list
    // print('ヴァl$val\n');
    //print('アンスゆら${ans_url}');
    for (int j = 0; j < val.length; j++) {
      if (ans_url[counta] != val[j]) {
        ansjudge.add(false);
      } else {
        ansjudge.add(true);
      }
    }
    //print('アンスジャッジ$ansjudge');
  }

  Future<void> getText() async {
    final snepshot = await FirebaseFirestore.instance
        .collection('math')
        .doc('facesheet')
        .get();
    facesheet.add(snepshot['face1']);
    facesheet.add(snepshot['bad']);
    facesheet.add(snepshot['good']);
    facesheet.add(snepshot['face2']);
    facesheet.add(snepshot['notconfident']);
    facesheet.add(snepshot['confident']);
    facesheet.add(snepshot['face3']);
    facesheet.add(snepshot['unknown']);
    facesheet.add(snepshot['know']);
    facesheet.add(snepshot['face4']);
    setState(() {});
  }

  //選択肢があっているか否か
  answer(String val) async {
    bool cor = false;
    stopTime();

    if (ans_url[counta] != val) {
      print('不正解');
      value -= 10;
      show = false; //不正解のshowdialog
      Text('false-');
      result.add('不正解');
      sort--;
      //firewrite();
    } else {
      value += 10;
      show = true;
      setState(() {});
      result.add('正解');
      sort++;
    }
  }

  Future<void> firewrite() async {
    //呼び出すのはselectが変わったあとで次へを押す前
    print('-------------------------------$counta');
    // final now = new DateTime.now();
    /*
    print('docList$docList');
    print('doclist${docList[i]}');
    print('リザルト$result'); //---------------------------ここでerror
    print('result${result[counta]}');
    print('count$count1');
    print('${time_lis1.elapsed}');
    print('out$out1');
    print('タイムアンス${time_ans.elapsed}');
    print('ansjudge$ansjudge');*/
    final now = new DateTime.now();

    await FirebaseFirestore.instance
        .collection('$user') // コレクションID--->名前入力でも良いかもね
        .doc('$now') // ここは空欄だと自動でIDが付く
        .set({
      '何問目': counta + 1,
      '選んだ選択肢': ansuser,
      'ボタンを押した時間': serviceTime,
      'que': '${docList[counta]}',
      'ansaudio': '${ansAudioUrlList[counta]}',
      'ans': '${result[counta]}',
      'inst': ['${selist[0]}', '${selist[1]}', '${selist[2]}', '${selist[3]}'],
      'soundbtn': [count1, count2, count3, count4, count5],
      'soundtime': [
        '${tsound1}',
        '${tsound2}',
        '${tsound3}',
        '${tsound4}',
        '${tsound5}'
      ],
      /*追加'resoundtime': [
        '${retime1.elapsed}',
        '${retime2.elapsed}',
        '${retime3.elapsed}',
        '${retime4.elapsed}',
        '${retime5.elapsed}'
      ],*/
      'allsoundtime': [
        '${time_lis1.elapsed}',
        '${time_lis2.elapsed}',
        '${time_lis3.elapsed}',
        '${time_lis4.elapsed}',
        '${time_lis5.elapsed}'
      ],
      'time_ans': '${time_ans.elapsed}',
      //追加'resoundbtn': [out1, out2, out3, out4, out5],
      'ansjudge': ansjudge,
      '実験主観難易度': [
        slidernum[slidernum.length - 1],
        slidernum2[slidernum2.length - 1],
        slidernum3[slidernum3.length - 1],
        slidernum4[slidernum4.length - 1],
      ]
    });
  }

  Future<bool> cupertino(BuildContext context, bool show, String url) async {
    //確認画面
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("確認"),
          content: Text("この回答でよろしいですか？"),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text("Return"),
                isDestructiveAction: true,
                onPressed: () {
                  final now = new DateTime.now();
                  serviceTime.add({'cancelbtn': '$now'});
                  Navigator.pop(context);
                }
                //=> Navigator.pop(context),
                ),
            CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () {
                  //@override
                  _diaEnabled = true;
                  answer(url);
                  final now = new DateTime.now();
                  serviceTime.add({'okbtn': '$now'});
                  setState(() {});
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
    return _diaEnabled;
  }

  //audiocacheクラスの初期化
  AudioPlayer player1 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player3 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player4 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player5 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //waveの出力
  final state = [false, false, false, false, false].cast<bool>();

  //eventのstateがplaying/stopped.or.completeの時の処理
  Future<void> playTime() async {
    player1.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        time_lis1.start();
        // !_diaEnabled ? time_lis1.start() : retime1.start();
        _diaEnabled ? retime1.start() : SizedBox();
        setState(() {
          state[0] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        time_lis1.stop();
        retime1.stop();
        setState(() {
          state[0] = false;
        });
      }
    });
    player2.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        time_lis2.start();
        _diaEnabled ? retime2.start() : SizedBox();
        setState(() {
          state[1] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        time_lis2.stop();
        retime2.stop();
        setState(() {
          state[1] = false;
        });
      }
    });
    player3.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        time_lis3.start();
        _diaEnabled ? retime3.start() : SizedBox();
        setState(() {
          state[2] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        time_lis3.stop();
        retime3.stop();
        setState(() {
          state[2] = false;
        });
      }
    });
    player4.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        time_lis4.start();
        _diaEnabled ? retime4.start() : SizedBox();
        setState(() {
          state[3] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        time_lis4.stop();
        retime4.stop();
        setState(() {
          state[3] = false;
        });
      }
    });
    player5.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        time_lis5.start();
        _diaEnabled ? retime5.start() : SizedBox();
        setState(() {
          state[4] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        time_lis5.stop();
        retime5.stop();
        setState(() {
          state[4] = false;
        });
      }
    });
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queExample();
    //Initialized();
    fetchName();
    playTime();
    getText();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double devicewidth = MediaQuery.of(context).size.width;
    //buildの中に変数書くの良くない
    return Scaffold(
      appBar: AppBar(
        title: Text('第${i + 1}問'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
              //縦
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (dlist.length > 9)
                  new SizedBox(
                    width: deviceheight * 0.5, //500
                    height: devicewidth * 0.049, //18.0
                    child: Text(
                      dlist.length > 2 ? dlist[counta] : '', //これが一番遅いかな
                      style: TextStyle(
                        fontSize: deviceheight * 0.02,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state[0] == true) WavePage(key: Key('0'), h: 0),
                    SizedBox(
                      height: deviceheight * 0.11, //100
                      width: deviceheight * 0.11, //100
                      child: FloatingActionButton(
                        onPressed: !_isEnabled
                            ? null
                            : () {
                                final now = new DateTime.now(); //いつボタン押したか。
                                serviceTime.add({'btn1': '$now'});

                                player2.stop();
                                player3.stop();
                                player4.stop();
                                player5.stop();
                                player1.play(ansAudioUrl[counta]);
                                //player1.play(ans_url[counta]);
                                !_diaEnabled ? count1++ : print(''); //何回押したか
                                _diaEnabled ? out1++ : print('');
                              },
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(
                          Icons.volume_up,
                          size: deviceheight * 0.05,
                        ),
                        heroTag: "btn1",
                      ),
                    ),
                  ],
                ),
                Row(
                    //横
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (state[1] == true) WavePage(key: Key('0'), h: 0),
                          SizedBox(
                            height: deviceheight * 0.085,
                            width: deviceheight * 0.085,
                            child: FloatingActionButton(
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(
                                Icons.volume_up,
                                size: deviceheight * 0.04,
                              ),
                              heroTag: "btn2",
                              onPressed: _isEnabled
                                  ? () {
                                      final now = new DateTime.now();
                                      serviceTime.add({'btn2': '$now'});
                                      player1.stop();
                                      player3.stop();
                                      player4.stop();
                                      player5.stop();
                                      player2.play(list[0]);
                                      print(_isEnabled);
                                      !_diaEnabled ? count2++ : print('');
                                      _diaEnabled ? out2++ : print('');
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      !_diaEnabled
                          ? new SizedBox(
                              height: deviceheight * 0.059,
                              width: devicewidth * 0.54,
                              child: ElevatedButton(
                                child: ans_url.length > 2
                                    ? Text(
                                        'select1',
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: deviceheight * 0.028,
                                        ),
                                      )
                                    : Text('loading'),
                                onPressed: !_isEnabled
                                    ? null
                                    : () {
                                        shape:
                                        OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        );
                                        stopsound();
                                        divsound();
                                        //btnタイムスタンプ
                                        final now = new DateTime.now();
                                        serviceTime
                                            .add({'elevatedbtn1': '$now'});
                                        ansuser = 1;

                                        //_diaEnabled = true;
                                        setState(() {});
                                        cupertino(
                                            context, _diaEnabled, list[0]);
                                        /*
                                        okBtn
                                            ? answer(list[0])
                                            : new SizedBox();*/
                                        /*追加
                                        return showAlert(
                                            context, show); //showdialog*/
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen,
                                  onPrimary: Colors.white,
                                ),
                              ),
                            )
                          : new SizedBox()
                      /*child: ansjudge[0]
                                  ? Icon(Icons.brightness_1_outlined,
                                      color: Colors.red,
                                      size: deviceheight * 0.1)
                                  : Icon(Icons.remove_circle_outline,
                                      color: Colors.blue,
                                      size: deviceheight * 0.1))*/
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(alignment: Alignment.center, children: [
                        if (state[2] == true) WavePage(key: Key('0'), h: 0),
                        new SizedBox(
                          width: deviceheight * 0.085,
                          height: deviceheight * 0.085,
                          child: FloatingActionButton(
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(
                                Icons.volume_up,
                                size: deviceheight * 0.04,
                              ),
                              heroTag: "btn3",
                              onPressed: !_isEnabled
                                  ? null
                                  : () {
                                      print("pre2"); //音を鳴らす
                                      final now = new DateTime.now();
                                      serviceTime.add({'btn3': '$now'});
                                      print(list[1]);
                                      player1.stop();
                                      player2.stop();
                                      player4.stop();
                                      player5.stop();
                                      player3.play(list[1]);
                                      !_diaEnabled
                                          ? count3++
                                          : print(''); //何回押したか
                                      _diaEnabled ? out3++ : print('');
                                    }),
                        ),
                      ]),
                      !_diaEnabled
                          ? new SizedBox(
                              height: deviceheight * 0.059,
                              width: devicewidth * 0.54,
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
                                        divsound();
                                        final now = new DateTime.now();
                                        serviceTime
                                            .add({'elevatedbtn2': '$now'});
                                        ansuser = 2;

                                        setState(() {});
                                        print('${ansjudge[1]}');

                                        cupertino(
                                            context, _diaEnabled, list[1]);

                                        //_diaEnabled = true;
                                        /*追加
                                        return showAlert(
                                            context, show); //showdialog*/
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen,
                                  onPrimary: Colors.white,
                                ),
                                child: (ans_url.length > 2
                                    ? Text(
                                        'select 2',
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: deviceheight * 0.028,
                                        ),
                                      )
                                    : Text('loading')),
                              ),
                            )
                          : new SizedBox()
                      /* child: ansjudge[1]
                                  ? Icon(Icons.brightness_1_outlined,
                                      color: Colors.red,
                                      size: deviceheight * 0.1)
                                  : Icon(Icons.remove_circle_outline,
                                      color: Colors.blue,
                                      size: deviceheight * 0.1),
                            )*/
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(alignment: Alignment.center, children: [
                        if (state[3] == true) WavePage(key: Key('0'), h: 0),
                        new SizedBox(
                          width: deviceheight * 0.085,
                          height: deviceheight * 0.085,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.volume_up,
                              size: deviceheight * 0.04,
                            ),
                            heroTag: "btn4",
                            onPressed: !_isEnabled
                                ? null
                                : () {
                                    print(list[2]);
                                    final now = new DateTime.now();
                                    serviceTime.add({'btn4': '$now'});
                                    player1.stop();
                                    player2.stop();
                                    player3.stop();
                                    player5.stop();
                                    player4.play(list[2]);
                                    !_diaEnabled
                                        ? count4++
                                        : print(''); //何回押したか
                                    _diaEnabled ? out4++ : print('');
                                  },
                          ),
                        ),
                      ]),
                      !_diaEnabled
                          ? new SizedBox(
                              height: deviceheight * 0.059,
                              width: devicewidth * 0.54,
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
                                          divsound();
                                          final now = new DateTime.now();
                                          serviceTime
                                              .add({'elevatedbtn3': '$now'});

                                          ansuser = 3;

                                          print('正解または不正解$show');
                                          //_diaEnabled = true;
                                          cupertino(
                                              context, _diaEnabled, list[2]);
                                          /*追
                                          return showAlert(context, show);*/
                                        },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen,
                                    onPrimary: Colors.white,
                                  ),
                                  child: ans_url.length > 2
                                      ? Text(
                                          'select 3',
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: deviceheight * 0.028,
                                          ),
                                        )
                                      : Text('loading')),
                            )
                          : new SizedBox()
                      /*child: ansjudge[2]
                                  ? Icon(Icons.brightness_1_outlined,
                                      color: Colors.red,
                                      size: deviceheight * 0.1)
                                  : Icon(Icons.remove_circle_outline,
                                      color: Colors.blue,
                                      size: deviceheight * 0.1),
                            ),*/
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(alignment: Alignment.center, children: [
                        if (state[4] == true) WavePage(key: Key('0'), h: 0),
                        SizedBox(
                          width: deviceheight * 0.08,
                          height: deviceheight * 0.08,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.volume_up,
                              size: deviceheight * 0.036,
                            ),
                            heroTag: "btn5",
                            onPressed: !_isEnabled
                                ? null
                                : () {
                                    print(list[3]);
                                    final now = new DateTime.now();
                                    serviceTime.add({'btn5': '$now'});
                                    player1.stop();
                                    player2.stop();
                                    player3.stop();
                                    player4.stop();
                                    player5.play(list[3]);
                                    !_diaEnabled
                                        ? count5++
                                        : print(''); //何回押したか
                                    _diaEnabled ? out5++ : print('');
                                  },
                          ),
                        ),
                      ]),
                      !_diaEnabled
                          //?
                          ? new SizedBox(
                              height: deviceheight * 0.059,
                              width: devicewidth * 0.54,
                              child: ElevatedButton(
                                  onPressed: !_isEnabled
                                      ? null
                                      : () async {
                                          shape:
                                          OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          );
                                          stopsound();
                                          divsound();
                                          final now = new DateTime.now();
                                          serviceTime
                                              .add({'elevatedbtn4': '$now'});
                                          ansuser = 4;
                                          await cupertino(
                                              context, show, list[3]);
                                          //answer(list[3]);
                                          /*追加
                                          return showAlert(context, show);*/
                                        },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen,
                                    onPrimary: Colors.white,
                                  ),
                                  child: !_isEnabled
                                      ? Text('loading')
                                      : Text(
                                          'select 4',
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: deviceheight * 0.028,
                                          ),
                                        )),
                            )
                          : new SizedBox()
                      /*: new SizedBox(
                              child: ansjudge[3]
                                  ? Icon(Icons.brightness_1_outlined,
                                      color: Colors.red,
                                      size: deviceheight * 0.1)
                                  : Icon(Icons.remove_circle_outline,
                                      color: Colors.blue,
                                      size: deviceheight * 0.1),
                            ),*/
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _diaEnabled
                        /*? FloatingActionButton.extended(
                            onPressed: !_isEnabled
                                ? null
                                : () {
                                    stopsound();
                                    final now = new DateTime.now();
                                    serviceTime.add({'NextButton': '$now'});
                                    i++;
                                    firewrite();
                                    _page++;
                                    counta++;
                                    passend();
                                  },
                            label: Text('Next'),
                            icon: Icon(Icons.arrow_forward_sharp),
                          )*/
                        ? new SizedBox()
                        : new SizedBox()
                  ],
                )
              ]),
          //----追加箇所-----//
          _diaEnabled
              ? Center(
                  child: _isEnabled
                      ? Container(
                          color: Color(0xFFE4E6F1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new SizedBox(
                                  height: deviceheight * 0.17,
                                  width: devicewidth * 0.95,
                                  child: SliderPage(slider[0], facesheet[0],
                                      facesheet[1], facesheet[2], slidernum)),
                              new SizedBox(
                                  height: deviceheight * 0.17,
                                  width: devicewidth * 0.95,
                                  child: SliderPage(slider[1], facesheet[3],
                                      facesheet[4], facesheet[5], slidernum2)),
                              new SizedBox(
                                  height: deviceheight * 0.17,
                                  width: devicewidth * 0.95,
                                  child: SliderPage(slider[2], facesheet[6],
                                      facesheet[7], facesheet[8], slidernum3)),
                              new SizedBox(
                                  height: deviceheight * 0.17,
                                  width: devicewidth * 0.95,
                                  child: SliderPage(slider[3], facesheet[9],
                                      facesheet[7], facesheet[8], slidernum4)),
                              new SizedBox(
                                  height: deviceheight * 0.1,
                                  width: devicewidth * 0.7,
                                  child: FloatingActionButton.extended(
                                    heroTag: "homebtn",
                                    onPressed: () {
                                      stopsound();
                                      firewrite();
                                      final now = new DateTime.now();
                                      serviceTime.add({'NextButton': '$now'});
                                      print(slidernum.length);
                                      print(
                                          'カレンと${slidernum[slidernum.length - 1]}');
                                      _page++;
                                      counta++;
                                      end.add(i);
                                      passend();
                                      print('slidernum4$slidernum4');
                                    },
                                    label: Text('Next',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: devicewidth * 0.04)),
                                    icon: Icon(Icons.arrow_forward_sharp),
                                  ))
                            ],
                          ))
                      : Text('sasa'),
                )
              : new SizedBox(),

          //----追加箇所------//
          Center(
            child: !_isEnabled
                ? Container(
                    color: Color(0xFFE4E6F1),
                  )
                : Text(''),
          ),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Horizon',
                    color: Colors.black,
                    fontWeight: FontWeight.w100),
                child: !_isEnabled
                    ? AnimatedTextKit(
                        animatedTexts: [
                          FadeAnimatedText(
                            'Loading...',
                          )
                        ],
                      )
                    : Text(''),
              ),
              SizedBox(
                height: deviceheight * 0.05,
              ),
              SizedBox(
                width: deviceheight * 0.05,
                height: deviceheight * 0.05,
                child: !_isEnabled
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        strokeWidth: deviceheight * 0.008,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                    : Text(''),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

//dialogshowalertの
void showAlert(BuildContext context, bool show) async {
  showDialog(
      context: context,
      builder: (context) {
        final double dvheight = MediaQuery.of(context).size.height;
        return AlertDialog(
          title: Stack(children: <Widget>[
            show
                ? Center(
                    child: Stack(children: <Widget>[
                      Icon(Icons.brightness_1_outlined,
                          color: Colors.red, size: dvheight * 0.3),
                      Text('正解',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: dvheight * 0.03)),
                    ]),
                  )
                : Center(
                    child: Stack(children: <Widget>[
                      Icon(Icons.remove_circle_outline,
                          color: Colors.blue, size: dvheight * 0.3),
                      Text('不正解',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: dvheight * 0.03)),
                    ]),
                  )
          ]),
        );
      });
}
