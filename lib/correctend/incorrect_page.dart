import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:music_memo/pie_chart/pie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(IncorPage());
}

class IncorPage extends StatefulWidget {
  IncorPage(this.e, this.i, this.o, this.k); //渡したい
  List e = [];
  int i;
  List o = [];
  String k = '';

  IncorPagePage createState() => IncorPagePage(e, i, o, k);
}

class IncorPagePage extends State<IncorPage> {
  IncorPagePage(this.param, this.nu, this.selurl, this.corurl);
  List param;
  int nu;
  List selurl;
  String corurl;

  //audioplayer
  AudioPlayer player1 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  GlobalKey _globalKey = GlobalKey();
  Image? _image; //宣言後に初期化されるnon-nullable変数の宣言ここでバグ

  Future<void> SetUrl() async {
    await player1.setUrl(selurl[nu]);
    await player2.setUrl(corurl);
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<void> PhotoData() async {
    //awaitがないと読み込まれない
    final photo_data = await firebase_storage.FirebaseStorage.instance //url
        .ref()
        .child('photo') //que_1とか
        .child('${param[nu]}.png') //lot
        .getDownloadURL();
    print('photodata');
    print(photo_data);
    print('soundurl${selurl[nu]}');
    print('selectans$corurl');

//    print('${param[nu]}');
    print(nu);
    //_image = new Image.network(photo_data);
    final image = new Image(image: new CachedNetworkImageProvider(photo_data));
    setState(() {
      _image = image;
    });
  }

  Future<void> SoundStop() async {
    player1.stop();
    player2.stop();
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetUrl();
    //image初期化？
    PhotoData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        SoundStop(); //戻るボタンで音鳴らし続けるのを防ぐ
        return Future.value(false);
      },
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('不正解'),
        ),
        body: Column(
          children: <Widget>[
            _image ?? SizedBox(),
            new SizedBox(
              height: 30,
            ),
            //nullならsizedboxを入れる
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
                children: <Widget>[
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('正解の音'),
                        new SizedBox(
                          height: 30,
                        ),
                        new SizedBox(
                          width: 80,
                          height: 80,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              player1.play(selurl[nu]);
                              player2.stop();
                              print('play${selurl[nu]}'); //url流す
                            },
                            child: Icon(Icons.volume_up),
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('あなたが選択した音'),
                        new SizedBox(
                          height: 30,
                        ),
                        new SizedBox(
                            width: 80,
                            height: 80,
                            child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                player2.play(corurl);
                                player1.stop();
                                print('play${corurl}'); //url流す
                              },
                              child: Icon(Icons.volume_up),
                            )),
                      ]),
                ]),
            /*
            PieChartSample2(),
            const SizedBox(
              height: 12,
            )*/
          ],
        ),
        /*
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 30, 40),
          padding: EdgeInsets.fromLTRB(10, 20, 50, 80),
          child: Text('不正解！'),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
        ),*/
      ),
    );
  }
}
