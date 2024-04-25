import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrustElementWidget extends StatelessWidget {
  final String text;
  final dynamic visualElement; // Puede ser IconData o AssetImage
  final bool isIcon; // Indica si visualElement es un icono o una imagen

  const TrustElementWidget({
    Key? key,
    required this.text,
    required this.visualElement,
    this.isIcon = true, // Predeterminado a true si se espera un icono
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
        width: 200,
        height: 200,
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
              isIcon
                  ? Icon(visualElement as IconData,
                      color: Colors.black, size: 65) // As Icon
                  : Image.asset(visualElement as String,
                      width: 120, height: 120), // As AssetImage
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
