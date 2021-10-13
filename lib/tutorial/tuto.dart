import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:music_memo/first.dart';
import 'package:music_memo/main.dart';
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
  TutoPage(this.user);
  String user;
  TutoPagePage createState() => TutoPagePage(user);
}

class TutoPagePage extends State<TutoPage> {
  TutoPagePage(this.user);
  String user;
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
  //ログデータ用

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
        setState(() {
          state[0] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        setState(() {
          state[0] = false;
        });
      }
    });
    player2.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        setState(() {
          state[1] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        //time_lis2.stop();
        //retime2.stop();
        setState(() {
          state[1] = false;
        });
      }
    });
    player3.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        setState(() {
          state[2] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        setState(() {
          state[2] = false;
        });
      }
    });
    player4.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        setState(() {
          state[3] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        setState(() {
          state[3] = false;
        });
      }
    });
    player5.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        setState(() {
          state[4] = true;
        });
      }
      if (event == PlayerState.STOPPED || event == PlayerState.COMPLETED) {
        setState(() {
          state[4] = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    findlist();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('さんの結果'),
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

                                isEnabled = true;
                                setState(() {});
                                return showAlert(context, show); //showdialog
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

                                isEnabled = true;
                                setState(() {});
                                return showAlert(context, show); //showdialog
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
                            heroTag: "btn4",
                            onPressed: () {
                              player1.stop();
                              player2.stop();
                              player3.stop();
                              player5.stop();
                              player4.play(soundlist[2]);
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

                                isEnabled = true;
                                setState(() {});
                                return showAlert(context, show); //showdialog
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

                                isEnabled = true;
                                setState(() {});
                                return showAlert(context, show); //showdialog
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEnabled
                        ? FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FirstPage(
                                          user, false, false, false)));
                            },
                            label: Text('Homeに戻る'),
                            icon: Icon(Icons.arrow_forward_sharp),
                          )
                        : new SizedBox()
                  ],
                )
              ])
        ]));
  }
}
