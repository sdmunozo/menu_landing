import 'dart:async';
import 'package:flutter/material.dart';

class ImageSwitcherWidget extends StatefulWidget {
  const ImageSwitcherWidget({super.key});

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
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 10,
              ),
              color: Colors.black,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      _imagePaths[_index],
                      key: ValueKey<int>(_index),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.zoom_in,
                    size: 70,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
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
          insetPadding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 10,
                    ),
                    color: Colors.black,
                  ),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
