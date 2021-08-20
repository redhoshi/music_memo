import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_memo/first.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userController = TextEditingController();
  var _passwordController = TextEditingController();
  bool user_id = false;
  int press_id = 0;

  Future<void> CheckPoint(_user) async {
    final result = new RegExp(r'^s[0-9]').hasMatch(_user);
    if (result != true) {
      print('useridが正しくない');
      user_id = false;
    } else {
      print('正しい');
      user_id = true;
    }
  }

  Future<void> TextApeal(press_id) async {
    press_id > 0
        ? Text('正しい値を入力せよ', textAlign: TextAlign.right)
        : Text('$press_id');
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
                '送信',
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                CheckPoint(_userController.text);
                print(user_id);
                user_id != true
                    ? setState(() {
                        press_id++;
                      })
                    //press_id += 1
                    : await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirstPage(
                                _userController.text,
                                _passwordController.text)),
                      );
                print('presss_id:$press_id');
              },
            ),
          ),
          press_id > 0
              ? Text('正しい値を入力せよ', textAlign: TextAlign.right)
              : Text('$press_id'),
        ]),
      ),
    );
  }
}
