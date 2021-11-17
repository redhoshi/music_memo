import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_memo/first.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

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
  //firebaseからuseridを取ってくる
  final docList = [];
  //firebaseからpassを取ってくる
  final password = [];
  //passwordの個数格納用
  int pacount = 0;
  //sectionの変数
  bool _isEnded1 = false;
  bool _isEnded2 = false;
  bool _isEnded3 = false;
  List countPage = [];
  final num = List<int>.generate(3, (i) => i + 0);

  calcurate(aiu) async {
    var dat;
    for (int j = 0; j < aiu.length; j++) {
      int lottery = math.Random().nextInt(j + 1);
      dat = aiu[j];
      aiu[j] = aiu[lottery];
      aiu[lottery] = dat;
    }
  }

//firestore
  Future<void> user() async {
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
    setState(() {});
    // print('usercontroller$_userController');
  }

  //Firebase上のパスワードとの一致
  Future<void> checkPass(_user, _pass) async {
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

  Future<void> sharedPre(String _user, String _pass) async {
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

  Future<void> readcount() async {
    final passcount = await FirebaseFirestore.instance
        .collection('math')
        .doc('password_count')
        .get();

    pacount = passcount['count'].toInt();
    print(pacount);
    print(password.length);
    setState(() {});
  }

  Future<void> loginData(user) async {
    final now = new DateTime.now();
    await FirebaseFirestore.instance
        .collection('$userさんのテスト') // コレクションID--->名前入力でも良いかもね
        .doc('$now') // ここは空欄だと自動でIDが付く
        .set({
      '問題順': num,
    });
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
    user();
    readcount();
    read();
    //Init();
  }

  @override
  Widget build(BuildContext context) {
    calcurate(num);
    print(num);
    final double deviceheight = MediaQuery.of(context).size.height;
    final double devicewidth = MediaQuery.of(context).size.width;

    /* return MaterialApp(
      title: 'music memory',

      home: Visual(),
      debugShowCheckedModeBanner: false,
      Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter Igniter!'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ), */
    //debugShowCheckedModeBanner: false,

    return Scaffold(
      appBar: AppBar(
        title: Text('ログインページ'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text('UserID'),
          new SizedBox(
            width: deviceheight * 0.3,
            height: devicewidth * 0.15,
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
            height: deviceheight * 0.02,
          ),
          Text('PassWord'),
          new SizedBox(
            width: deviceheight * 0.3,
            height: devicewidth * 0.15,
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
            height: deviceheight * 0.04,
          ),
          new SizedBox(
            width: devicewidth * 0.3,
            height: deviceheight * 0.06,
            child: password.length > pacount
                ? NeumorphicButton(
                    child: Text(
                      'ログイン',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: deviceheight * 0.02,
                      ),
                    ),
                    onPressed: //passwordはリストがないのはなぜ？
                        () async {
                      checkPass(_userController.text, _passwordController.text);
                      sharedPre(_userController.text, _passwordController.text);
                      print(user_id);
                      print(
                          'user:${_userController.text}pass:${_passwordController.text}');
                      print(user_id);
                      loginData(_userController.text);
                      user_id != true
                          ? setState(() {
                              press_id++;
                            })
                          : await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FirstPage(
                                      _userController.text,
                                      _isEnded1,
                                      _isEnded2,
                                      _isEnded3,
                                      num,
                                      countPage)),
                            );
                      print('presss_id:$press_id');
                    },
                  )
                : null,
          ),
          new SizedBox(
            height: deviceheight * 0.03,
          ),
          press_id > 0
              ? Text('正しい値を入力してください', textAlign: TextAlign.right)
              : Text(''), //press_id
        ]),
      ),
    );
    //)
  }
}

/*　まとめよう
class Visual extends StatelessWidget {
  const Visual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
            //child: RandomWords(),
            ),
      ),
    );
  }
}
*/
