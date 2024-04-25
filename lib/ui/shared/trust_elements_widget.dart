import 'package:flutter/material.dart';

class TrustElementWidget extends StatelessWidget {
  final String text;
  final dynamic visualElement;
  final bool isIcon;

  const TrustElementWidget({
    super.key,
    required this.text,
    required this.visualElement,
    this.isIcon = true,
  });

  TextStyle subtitleStyle(BoxConstraints constraints) => const TextStyle(
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
          color: const Color.fromARGB(51, 201, 226, 242),
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
              const SizedBox(
                height: 10,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
