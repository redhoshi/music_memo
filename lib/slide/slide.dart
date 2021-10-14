import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SliderPage extends StatelessWidget {
  //const SliderPage({Key? key}) : super(key: key);
  SliderPage(this._currentSliderValue, this.face1, this.face2, this.face3,
      this.slidernum);
  var _currentSliderValue;
  String face1, face2, face3;
  List slidernum = [];

  MyStatefulWidget createState() =>
      MyStatefulWidget(_currentSliderValue, face1, face2, face3, slidernum);
  //static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    //final double deviceheight = MediaQuery.of(context).size.height;
    return AspectRatio(
        aspectRatio: 3.0,
        child: Column(
          children: <Widget>[
            MyStatefulWidget(
                _currentSliderValue, face1, face2, face3, slidernum),
          ],
        ));
  }
}

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class MyStatefulWidget extends StatefulWidget {
  //const MyStatefulWidget({Key? key}) : super(key: key);
  MyStatefulWidget(this._currentSliderValue, this.face1, this.face2, this.face3,
      this.slidernum);
  var _currentSliderValue;
  String face1, face2, face3;
  List slidernum = [];

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(
      _currentSliderValue, face1, face2, face3, slidernum);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  _MyStatefulWidgetState(this._currentSliderValue, this.face1, this.face2,
      this.face3, this.slidernum);
  var _currentSliderValue;
  String face1, face2, face3;
  List slidernum = [];

  final facesheet = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('$face1'),
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
            _currentSliderValue = value;
            setState(() {
              //_currentSliderValue = value;
              slidernum.add(value);
            });

            print('かかか$_currentSliderValue');
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$_currentSliderValue',
          ),
          Text(
            '$face3',
          ),
        ],
      ),
    ]);
  }
}
