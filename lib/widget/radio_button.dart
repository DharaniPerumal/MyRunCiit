import 'package:flutter/material.dart';

class MyRadioWidget extends StatefulWidget {
  @override
  _MyRadioWidgetState createState() => _MyRadioWidgetState();
}

class _MyRadioWidgetState extends State<MyRadioWidget> {
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as int;
                });
              },
            ),
            Text('Male',style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 2,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as int;
                });
              },
            ),
            Text('Female',style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      ],
    );
  }
}
