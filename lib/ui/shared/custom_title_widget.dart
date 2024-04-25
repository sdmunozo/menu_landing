import 'package:flutter/material.dart';

class CustomTitleWidget extends StatelessWidget {
  final String text;
  final BoxConstraints constraints;
  final double maxWidth;

  CustomTitleWidget({
    Key? key,
    required this.text,
    required this.constraints,
    required this.maxWidth,
  }) : super(key: key);

  TextStyle _titleStyle() => TextStyle(
        fontFamily: 'Helvetica',
        fontSize: constraints.maxWidth > maxWidth ? 24 + 10 : 24,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          text,
          style: _titleStyle(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Container(
          height: 3,
          width: 130,
          color: Colors.green,
        ),
      ],
    );
  }
}
