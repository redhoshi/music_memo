import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FlutterOverboardPage extends StatefulWidget {
  FlutterOverPage createState() => FlutterOverPage();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(IncorPage());
}

class FlutterOverPage extends State<FlutterOverboardPage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Image? _image;
  Future<void> PhotoData() async {
    final photo_data = await firebase_storage.FirebaseStorage.instance //url
        .ref()
        .child('tutorial') //que_1とか
        .child('que.png') //lot
        .getDownloadURL();
    final image = new Image(image: new CachedNetworkImageProvider(photo_data));
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterOverboardPage'),
      ),
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          // when user select SKIP
          Navigator.pop(context);
        },
        finishCallback: () {
          // when user select NEXT
          Navigator.pop(context);
        },
      ),
    );
  }

  final pages = [
    PageModel.withChild(
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Column(
            children: <Widget>[
              Text(
                "さあ、始めましょう",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              Text(
                "下のボタンを押すと音が発生する",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              //Image.network(
              //   'https://firebasestorage.googleapis.com/v0/b/mmmm-56c1c.appspot.com/o/tutorial%2Fans.png?alt=media&token=f47b8071-a57f-4376-9cdc-65c65517a44d'),
              new SizedBox(
                height: 100,
              ),
              new SizedBox(
                height: 100,
                width: 100,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.ac_unit_rounded),
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
            ],
            //child:Image.network('https://firebasestorage.googleapis.com/v0/b/mmmm-56c1c.appspot.com/o/tutorial%2Fque.png?alt=media&token=cdfa01b3-7899-40da-a019-fff09cfe8e85'),
          ),
          /*
          child: Text(
            "さあ、始めましょう",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),*/
        ),
        color: const Color(0xFF5886d6),
        doAnimateChild: true),
    //),
    PageModel.withChild(
        child: Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Text(
              "さあ、始めましょう",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            )),
        color: const Color(0xFF5886d6),
        doAnimateChild: true),
    PageModel.withChild(
        child: Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Text(
              "さあ、始めましょう",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            )),
        color: const Color(0xFF5886d6),
        doAnimateChild: true)
  ];
}
