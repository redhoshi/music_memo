import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:music_memo/first.dart';
import 'package:music_memo/main.dart';
import 'package:music_memo/slide/slide.dart';
import 'package:music_memo/wave/wave.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

//firebasestorage初期化
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class TutoPage extends StatefulWidget {
  //TutoPage();
  TutoPage(this.user, this.num, this.countPage);
  String user;
  final num;
  List countPage;
  TutoPagePage createState() => TutoPagePage(user, num, countPage);
}

class TutoPagePage extends State<TutoPage> {
  TutoPagePage(this.user, this.num, this.countPage);
  String user;
  List countPage;
  //問題リスト
  String quelist = 'aiu';
  //答えのリスト
  final anslist = [];
  //問題の音リスト
  final quesound = [];
  //問題の音urlリスト
  final anssound = [];
  //選択肢の音urlリスト
  final soundlist = [];
  //elevatedを押した押してない
  bool isEnabled = false;
  //正解or不正解
  bool show = false;
  //urllistが取れたら
  bool _getEnabled = false;
  final num; //section3
  //ログデータ用音sound時間
  //音源データを聞いている時間
  Stopwatch stime1 = Stopwatch();
  Stopwatch stime2 = Stopwatch();
  Stopwatch stime3 = Stopwatch();
  Stopwatch stime4 = Stopwatch();
  Stopwatch stime5 = Stopwatch();
  //slider初期値
  final slider = [50.0, 50.0, 50.0, 50.0];

  List slidernum = [50],
      slidernum2 = [50],
      slidernum3 = [50],
      slidernum4 = [50];
  final facesheet = [];
  //いつなんのボタンを押したか
  final List<Map<String, dynamic>> serviceTime = [];

  Future<void> initialized() async {
    //ボタンのタイムスタンプの初期化
    serviceTime.removeRange(0, serviceTime.length);
  }

  //問題リストと答えのリストを取得
  Future<void> findlist() async {
    final snepshot = await FirebaseFirestore.instance
        .collection('testquestion')
        .doc('tque1')
        .get();
    anslist.add(snepshot['audio']);
    // quelist.add(snepshot['que']);
    quelist = snepshot['que'].toString();
    getsound();
    setState(() {});
  }

  //firebaseから音データを取得
  Future<void> getsound() async {
    //正解データの音URL
    final ansaudio = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('sound4') /*audio->sound */
        .child('tque1') //que_1
        .child(anslist[0]) //dri_tp
        .getDownloadURL();
    anssound.add(ansaudio);
    //問題データの音URL
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('sound4')
        .child('tque1')
        .listAll();
    result.items.forEach((firebase_storage.Reference ref) async {
      final path = await firebase_storage.FirebaseStorage.instance //url取れてる
          .ref(ref.fullPath)
          .fullPath; //パスを取得
      quesound.add(path.substring(
        13,
      ));
      if (quesound.length > 3) geturl(quesound);
      setState(() {});
    });
  }

  Future<void> geturl(quesound) async {
    for (int i = 0; i < quesound.length; i++) {
      final queurl = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('sound4') /*audio->sound */
          .child('tque1') //que_1
          .child(quesound[i]) //dri_tp
          .getDownloadURL();
      soundlist.add(queurl);
    }
    print('soundlist-----${soundlist}');
    for (int i = 0; i < 4; i++) {
      setUrl(i);
    }
    _getEnabled = true;
    setState(() {});
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

  //audiocacheクラスの初期化
  AudioPlayer player1 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player3 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player4 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player5 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //audioplayerを読み込ませる
  Future<void> setUrl(n) async {
    int i = 0;
    switch (n) {
      case 0:
        await player1.setUrl(soundlist[0]);
        i++;
        break;
      case 1:
        await player2.setUrl(soundlist[1]);
        i++;
        break;
      case 2:
        await player3.setUrl(soundlist[2]);
        i++;
        break;
      case 3:
        await player4.setUrl(soundlist[3]);
        i++;
        break;
    }
    print(i);
  }

  Future<void> stopsound() async {
    player1.stop();
    player2.stop();
    player3.stop();
    player4.stop();
    player5.stop();
  }

  //waveの出力
  final state = [false, false, false, false, false].cast<bool>();
  Future<void> playTime() async {
    player1.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        //time_lis1.start();
        stime1.start();
        setState(() {
          state[0] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        stime1.stop();
        setState(() {
          state[0] = false;
        });
      }
    });
    player2.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        stime2.start();
        setState(() {
          state[1] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        //time_lis2.stop();
        //retime2.stop();
        stime2.stop();
        setState(() {
          state[1] = false;
        });
      }
    });
    player3.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        stime3.start();
        setState(() {
          state[2] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        stime3.stop();
        setState(() {
          state[2] = false;
        });
      }
    });
    player4.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        stime4.start();
        setState(() {
          state[3] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        stime4.stop();
        setState(() {
          state[3] = false;
        });
      }
    });
    player5.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        stime5.start();
        setState(() {
          state[4] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        stime5.stop();
        setState(() {
          state[4] = false;
        });
      }
    });
  }

  Future<void> writelog() async {
    final now = new DateTime.now();
    await FirebaseFirestore.instance
        .collection('$userさんのテスト') // コレクションID--->名前入力でも良いかもね
        .doc('$now') // ここは空欄だと自動でIDが付く
        .set({
      'sountime': [
        '${stime1.elapsed}',
        '${stime2.elapsed}',
        '${stime3.elapsed}',
        '${stime4.elapsed}',
        '${stime5.elapsed}'
      ],
      'ボタンログ': serviceTime,
      'アンケート': [
        slidernum[slidernum.length - 1],
        slidernum2[slidernum2.length - 1],
        slidernum3[slidernum3.length - 1],
        slidernum4[slidernum4.length - 1]
      ],
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    findlist();
    playTime();
    getText();
    initialized();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('$userさんのお試し'),
          automaticallyImplyLeading: false,
        ),
        body: Stack(children: [
          Column(
              //縦
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                  width: deviceheight * 0.5, //500
                  height: devicewidth * 0.049, //18.0
                  child: Text(
                    '${quelist}',
                    style: TextStyle(fontSize: deviceheight * 0.017),
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
                        onPressed: () {
                          player2.stop();
                          player3.stop();
                          player4.stop();
                          player5.stop();
                          player1.play(anssound[0]);
                          final now = new DateTime.now(); //いつボタン押したか。
                          serviceTime.add({'soundbtn1': '$now'});
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
                            onPressed: () {
                              player1.stop();
                              player3.stop();
                              player4.stop();
                              player5.stop();
                              player2.play(soundlist[0]);
                              final now = new DateTime.now(); //いつボタン押したか。
                              serviceTime.add({'soundbtn2': '$now'});
                            },
                          ),
                        ),
                      ],
                    ),
                    !isEnabled
                        ? new SizedBox(
                            height: deviceheight * 0.059,
                            width: devicewidth * 0.54,
                            child: ElevatedButton(
                              child: Text('select1'),
                              onPressed: () {
                                shape:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                );
                                stopsound();
                                final now = new DateTime.now(); //いつボタン押したか。
                                serviceTime.add({'elebtn1': '$now'});

                                isEnabled = true;
                                setState(() {});
                                //追加return showAlert(context, show); //showdialog
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen,
                                onPrimary: Colors.white,
                              ),
                            ),
                          )
                        : new SizedBox(
                            child: !show
                                ? Icon(Icons.brightness_1_outlined,
                                    color: Colors.red, size: deviceheight * 0.1)
                                : Icon(Icons.remove_circle_outline,
                                    color: Colors.blue,
                                    size: deviceheight * 0.1)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (state[2] == true) WavePage(key: Key('0'), h: 0),
                        SizedBox(
                          height: deviceheight * 0.085,
                          width: deviceheight * 0.085,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.volume_up,
                              size: deviceheight * 0.04,
                            ),
                            heroTag: "btn3",
                            onPressed: () {
                              player1.stop();
                              player2.stop();
                              player4.stop();
                              player5.stop();
                              player3.play(soundlist[1]);
                              final now = new DateTime.now(); //いつボタン押したか。
                              serviceTime.add({'soundbtn3': '$now'});
                            },
                          ),
                        ),
                      ],
                    ),
                    !isEnabled
                        ? new SizedBox(
                            height: deviceheight * 0.059,
                            width: devicewidth * 0.54,
                            child: ElevatedButton(
                              child: Text('select2'),
                              onPressed: () {
                                shape:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                );
                                stopsound();
                                final now = new DateTime.now(); //いつボタン押したか。
                                serviceTime.add({'elebtn2': '$now'});
                                isEnabled = true;
                                setState(() {});
                                //追加return showAlert(context, show); //showdialog
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen,
                                onPrimary: Colors.white,
                              ),
                            ),
                          )
                        : new SizedBox(
                            child: !show
                                ? Icon(Icons.brightness_1_outlined,
                                    color: Colors.red, size: deviceheight * 0.1)
                                : Icon(Icons.remove_circle_outline,
                                    color: Colors.blue,
                                    size: deviceheight * 0.1)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (state[3] == true) WavePage(key: Key('0'), h: 0),
                        SizedBox(
                          height: deviceheight * 0.085,
                          width: deviceheight * 0.085,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.volume_up,
                              size: deviceheight * 0.04,
                            ),
                            heroTag: "btn4",
                            onPressed: () {
                              player1.stop();
                              player2.stop();
                              player3.stop();
                              player5.stop();
                              player4.play(soundlist[2]);
                              final now = new DateTime.now(); //いつボタン押したか。
                              serviceTime.add({'soundbtn4': '$now'});
                            },
                          ),
                        ),
                      ],
                    ),
                    !isEnabled
                        ? new SizedBox(
                            height: deviceheight * 0.059,
                            width: devicewidth * 0.54,
                            child: ElevatedButton(
                              child: Text('select3'),
                              onPressed: () {
                                shape:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                );
                                stopsound();
                                final now = new DateTime.now(); //いつボタン押したか。
                                serviceTime.add({'elebtn3': '$now'});
                                show = true;
                                isEnabled = true;
                                setState(() {});
                                //追加return showAlert(context, show); //showdialog
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen,
                                onPrimary: Colors.white,
                              ),
                            ),
                          )
                        : new SizedBox(
                            child: show
                                ? Icon(Icons.brightness_1_outlined,
                                    color: Colors.red, size: deviceheight * 0.1)
                                : Icon(Icons.remove_circle_outline,
                                    color: Colors.blue,
                                    size: deviceheight * 0.1)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (state[4] == true) WavePage(key: Key('0'), h: 0),
                        SizedBox(
                          height: deviceheight * 0.085,
                          width: deviceheight * 0.085,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.volume_up,
                              size: deviceheight * 0.04,
                            ),
                            heroTag: "btn5",
                            onPressed: () {
                              player1.stop();
                              player2.stop();
                              player4.stop();
                              player3.stop();
                              player5.play(soundlist[3]);
                              final now = new DateTime.now(); //いつボタン押したか。
                              serviceTime.add({'soundbtn5': '$now'});
                            },
                          ),
                        ),
                      ],
                    ),
                    !isEnabled
                        ? new SizedBox(
                            height: deviceheight * 0.059,
                            width: devicewidth * 0.54,
                            child: ElevatedButton(
                              child: Text('select4'),
                              onPressed: () {
                                shape:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                );
                                stopsound();
                                final now = new DateTime.now(); //いつボタン押したか。
                                serviceTime.add({'elebtn4': '$now'});
                                isEnabled = true;
                                setState(() {});
                                //追加return showAlert(context, show); //showdialog
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen,
                                onPrimary: Colors.white,
                              ),
                            ),
                          )
                        : new SizedBox(
                            child: !show
                                ? Icon(Icons.brightness_1_outlined,
                                    color: Colors.red, size: deviceheight * 0.1)
                                : Icon(Icons.remove_circle_outline,
                                    color: Colors.blue,
                                    size: deviceheight * 0.1)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEnabled
                        ? FloatingActionButton.extended(
                            onPressed: () {
                              stopsound();
                              writelog();

                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FirstPage(
                                          user,
                                          false,
                                          false,
                                          false,
                                          num,
                                          countPage)));
                            },
                            label: Text('Homeに戻る'),
                            icon: Icon(Icons.arrow_back_sharp),
                          )
                        : new SizedBox()
                  ],
                ),
              ]),
          isEnabled
              ? Center(
                  child: Container(
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
                                  print(slidernum3);
                                  stopsound();
                                  writelog();
                                  final now = new DateTime.now(); //いつボタン押したか。
                                  serviceTime.add({'homebtn': '$now'});
                                  Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FirstPage(
                                              user,
                                              false,
                                              false,
                                              false,
                                              num,
                                              countPage)));
                                },
                                label: Text('Homeに戻る'),
                                icon: Icon(Icons.arrow_back_sharp),
                              ))
                        ],
                      )),
                )
              : new SizedBox(),
          Center(
            child: !_getEnabled
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
                child: !_getEnabled
                    ? AnimatedTextKit(
                        animatedTexts: [FadeAnimatedText('Loading...')],
                      )
                    : Text(''),
              ),
              SizedBox(
                height: deviceheight * 0.05,
              ),
              SizedBox(
                width: deviceheight * 0.05,
                height: deviceheight * 0.05,
                child: !_getEnabled
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        strokeWidth: deviceheight * 0.008,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                    : Text(''),
              ),
            ]),
          ),
        ]));
  }
}
