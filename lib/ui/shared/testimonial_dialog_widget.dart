import 'package:flutter/material.dart';

class TestimonialDialog extends StatelessWidget {
  final String imagePath;

  const TestimonialDialog({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 10),
                color: Colors.black,
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
