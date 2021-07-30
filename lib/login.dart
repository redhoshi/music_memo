import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userController = TextEditingController();
  var _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
        centerTitle: true,
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Center(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //children: <Widget>[
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new SizedBox(
            width: 300,
            height: 80,
            child: TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Username',
                icon: Icon(Icons.account_circle),
              ),
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
            ),
          ),
          new SizedBox(
            width: 300,
            height: 80,
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'PassWord',
                hintText: 'PassWord',
                icon: Icon(Icons.security),
              ),
              autocorrect: false,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
          ),
          new SizedBox(
            width: 200,
            height: 50,
            child: Neumorphic(
              style: NeumorphicStyle(depth: -5),
              child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
