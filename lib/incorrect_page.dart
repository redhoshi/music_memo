import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(IncorPage());
}

class IncorPage extends StatefulWidget {
  IncorPage(this.e, this.i); //渡したい
  List e = [];
  int i;

  IncorPagePage createState() => IncorPagePage(e, i);
}

class IncorPagePage extends State<IncorPage> {
  IncorPagePage(this.param, this.nu);
  List param;
  int nu;
  GlobalKey _globalKey = GlobalKey();
  Image? _image; //宣言後に初期化されるnon-nullable変数の宣言ここでバグ

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<void> PhotoData() async {
    //awaitがないと読み込まれない
    final photo_data = await firebase_storage.FirebaseStorage.instance //url
        .ref()
        .child('photo') //que_1とか
        .child('${param[nu]}.jpeg') //lot
        .getDownloadURL();
    print('photodata');
    print(photo_data);

    print('${param[nu]}');
    print(nu);
    //_image = new Image.network(photo_data);
    final image = new Image(image: new CachedNetworkImageProvider(photo_data));
    setState(() {
      _image = image;
    });
  }

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //image初期化？
    PhotoData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('不正解'),
      ),
      body: Column(
        children: [
          _image ?? SizedBox(),
          //nullならsizedboxを入れる
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // これを設定
              children: <Widget>[
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      print('aiu'); //url流す
                    }),
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      print('aiu'); //url流す
                    })
              ]),
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
    );
  }
}
