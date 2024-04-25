import 'dart:async';
import 'package:flutter/material.dart';

class ImageSwitcherWidget extends StatefulWidget {
  @override
  _ImageSwitcherWidgetState createState() => _ImageSwitcherWidgetState();
}

class _ImageSwitcherWidgetState extends State<ImageSwitcherWidget> {
  int _index = 0;
  final List<String> _imagePaths = [
    'assets/MenuScreens/WelcomeScreen.jpeg',
    'assets/MenuScreens/HomeScreen.jpeg',
    'assets/MenuScreens/SingleItemScreen.jpeg',
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        _index = (_index + 1) % _imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, _imagePaths[_index]),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                _imagePaths[_index],
                key: ValueKey<int>(_index),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                    0.4), // Difumina el ícono con un overlay semitransparente
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .zoom_in, // Ícono de zoom, sugerente para hacer clic y ver en detalle
                size: 50,
                color: Colors.white.withOpacity(
                    0.7), // Ícono blanco con opacidad para suavizar su visibilidad
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}
