import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SliderPage extends StatelessWidget {
  const SliderPage({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.3,
        child: Column(
          children: <Widget>[
            MyStatefulWidget(),
          ],
        ));
  }
}

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double _currentSliderValue = 20;

  Future<void> getText() async {
    final snepshot = await FirebaseFirestore.instance
        .collection('math')
        .doc('facesheet')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('aiueo'),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTickMarkColor: Colors.white,
        ),
        child: Slider(
          value: _currentSliderValue,
          min: 0,
          max: 100,
          divisions: 4,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '良い',
          ),
          Text(
            '悪い',
          ),
        ],
      ),
      Text('大変ですか'),
      Slider(
        value: _currentSliderValue,
        min: 0,
        max: 100,
        divisions: 5,
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
    ]);
  }
}
