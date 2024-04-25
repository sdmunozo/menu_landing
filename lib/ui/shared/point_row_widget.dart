import 'package:flutter/material.dart';

class PointRowWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String iconPosition;
  final BoxConstraints constraints;
  final double maxWidth;

  const PointRowWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.iconPosition,
    required this.constraints,
    required this.maxWidth,
  });

  double responsiveFontSize(double baseSize, BoxConstraints constraints) {
    return constraints.maxWidth > maxWidth ? baseSize + 10 : baseSize;
  }

  TextStyle subtitleStyle(BoxConstraints constraints) => TextStyle(
        fontFamily: 'Helvetica',
        fontSize: responsiveFontSize(20, constraints),
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = iconPosition == "left"
        ? [
            Icon(icon, color: Colors.green, size: 50),
            SizedBox(width: 15),
            Expanded(
              child: Text(text, style: subtitleStyle(constraints)),
            ),
          ]
        : [
            Expanded(
              child: Text(text, style: subtitleStyle(constraints)),
            ),
            SizedBox(width: 15),
            Icon(icon, color: Colors.green, size: 50),
          ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );
  }
}
