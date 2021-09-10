import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_memo/calender/calender.dart';
import 'package:music_memo/first.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userController = TextEditingController(text: '');
  var _passwordController = TextEditingController(text: '');
  bool user_id = false;
  int press_id = 0;
  final docList = [];
  final password = [];

//firestore
  Future<void> User() async {
    await FirebaseFirestore.instance
        .collection('userid')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                docList.add(doc.id);
              }),
            });
    print(docList);
    for (int i = 0; i < docList.length; i++) {
      final snepshot = await FirebaseFirestore.instance
          .collection('userid')
          .doc(docList[i])
          .get();
      password.add('${snepshot['password']}');
    }
    print('password:$password');
    // print('usercontroller$_userController');
  }

  //Firebase上のパスワードとの一致
  Future<void> CheckPass(_user, _pass) async {
    for (int i = 0; i < docList.length; i++) {
      if (_user == docList[i]) {
        print('1');
        if (_pass == password[i]) {
          user_id = true;
          print('2');
          break;
        } else {
          user_id = false;
          print("3");
        }
      } else {
        user_id = false;
      }
    }
  }

  //shared_preferencesを使ってみる

  Future<void> SharedPre(String _user, String _pass) async {
    int i = 0;
    String m = 'aiu';

    //instancを取得
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //保存
    prefs.setString('userid', _user);
    prefs.setString('passid', _pass);
    print('user:$_user');
    setState(() {});
  }

  Future<void> read() async {
    //instancを取得
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.get('userid');
    _userController.text = prefs.getString(
          'userid',
        ) ??
        '';
    prefs.get('passid');
    _passwordController.text = prefs.getString(
          'passid',
        ) ??
        '';
    setState(() {});
  }
/*
  Future<void> Init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userController = new TextEditingController(text: '');
  }*/

  //画面が作られたときに一度だけ呼ばれる
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User();
    read();
    //Init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
        centerTitle: true,
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text('UserName'),
          new SizedBox(
            width: 200,
            height: 50,
            child: Neumorphic(
              style: NeumorphicStyle(depth: -5),
              child: TextField(
                controller: _userController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  )),
                  border: InputBorder.none,
                ),
                autocorrect: false,
                autofocus: true,
              ),
            ),
          ),
          new SizedBox(
            height: 30,
          ),
          Text('PassWord'),
          new SizedBox(
            width: 200,
            height: 50,
            child: Neumorphic(
              style: NeumorphicStyle(depth: -5),
              child: TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  )),
                  border: InputBorder.none,
                ),
                autocorrect: false,
                autofocus: true,
                obscureText: true,
              ),
            ),
          ),
          new SizedBox(
            height: 60,
          ),
          new SizedBox(
            width: 100,
            height: 40,
            child: NeumorphicButton(
              child: Text(
                'ログイン',
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                CheckPass(_userController.text, _passwordController.text);
                SharedPre(_userController.text, _passwordController.text);
                print(user_id);
                print(
                    'user:${_userController.text}pass:${_passwordController.text}');
                print(user_id);
                user_id != true
                    ? setState(() {
                        press_id++;
                      })
                    : await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CalenderExample(_userController.text)),
                      );
                print('presss_id:$press_id');
              },
            ),
          ),
          new SizedBox(
            height: 30,
          ),
          press_id > 0
              ? Text('正しい値を入力してください', textAlign: TextAlign.right)
              : Text(''), //press_id
        ]),
      ),
    );
  }
}
