import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    /*
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      home: Visual(),
    );*/
    return Visual();
  }
}

class Visual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
/*
class Visual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(),
    );
  }
}*/
/*
class Visual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //debugShowCheckedModeBanner: false,
      // title: 'Welcome to Flutter',
      home: Scaffold(
          /*appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
            //child: RandomWords(),
            ),*/
          ),
    );
  }
}*/
