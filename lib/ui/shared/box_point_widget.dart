import 'package:flutter/material.dart';

class BoxPointWidget extends StatelessWidget {
  final String point;
  final String text;
  final IconData icon;
  final BoxConstraints constraints;
  final double maxWidth;

  const BoxPointWidget({
    Key? key,
    required this.point,
    required this.text,
    required this.icon,
    required this.constraints,
    required this.maxWidth,
  }) : super(key: key);

  TextStyle subtitleStyle(BoxConstraints constraints) => TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 330,
        height: 330,
        decoration: BoxDecoration(
          color: Color.fromARGB(51, 201, 226, 242),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(42, 0, 0, 0),
            width: 1, // Grosor del borde
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.green, size: 100),
              SizedBox(
                height: 5,
              ),
              Text(
                point,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                text,
                style: subtitleStyle(constraints),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
