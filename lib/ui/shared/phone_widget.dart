import 'package:flutter/material.dart';

class PhoneWidget extends StatelessWidget {
  final String backgroundImageUrl;

  const PhoneWidget({super.key, required this.backgroundImageUrl});

  @override
  Widget build(BuildContext context) {
    double width = 300;
    double height = width * 2.17;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 10,
          ),
          image: DecorationImage(
            image: NetworkImage(backgroundImageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
