import 'package:flutter/material.dart';

class CorrectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('正解'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 20, 30, 40),
        padding: EdgeInsets.fromLTRB(10, 20, 50, 80),
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('正解！'),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
      ),
    );
  }
}
