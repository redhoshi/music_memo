import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class ThanksPage extends StatefulWidget {
  ThanksPagePage createState() => ThanksPagePage();
}

class ThanksPagePage extends State<ThanksPage> {
  GlobalKey _globalKey = GlobalKey();
  Image? _image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<void> PhotoData() async {
    //awaitがないと読み込まれない
    final photo_data = await firebase_storage.FirebaseStorage.instance //url
        .ref()
        .child('photo') //que_1とか
        .child('thanks2.png') //lot
        .getDownloadURL();
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
    PhotoData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildsss
    return Scaffold(
      appBar: AppBar(
        title: Text('実験は以上です'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _image ?? SizedBox(),
          new SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
