import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    child: Container(
                      color: Colors.black,
                      child: Image.asset(
                        _imagePaths[_index],
                        key: ValueKey<int>(_index),
                        fit: BoxFit.contain,
                      ),
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
    logImageZoomEvent(imagePath);
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

// Función para logear el evento de ampliación de imagen
  void logImageZoomEvent(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();
    String imageName = imagePath.split('/').last.split('.').first;

    // Creando el objeto de detalles del evento
    EventDetails details = EventDetails(
        imageId:
            imagePath, // Asumiendo que el 'imageId' se refiere a la ruta de la imagen
        linkLabel:
            imageName // 'linkLabel' puede usarse para almacenar el nombre de la imagen
        );

    // Creando el objeto del evento principal
    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'defaultSessionId',
        eventType: 'ImageZoom',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    if (kDebugMode) {
      //print(event.toJson()); // Utiliza toJson para imprimir el evento
    }

    // Imprimir mensaje después de lanzar la URL
    // print('Enviando eventos pendientes... ImageZoom ${details.linkLabel}');
    Provider.of<UserEventProvider>(context, listen: false).addEvent(event);
  }

/*
  // Función para logear el evento de ampliación de imagen
  void logImageZoomEvent(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();
    String imageName = imagePath.split('/').last.split('.').first;

    var event = {
      "userId": userId ?? 'defaultUserId',
      "SessionId": sessionId ?? 'defaultSessionId',
      "EventType": "ImageZoom",
      "EventTimestamp": eventTimestamp,
      "EventDetails": {"ImagePath": imagePath, "ImageName": imageName}
    };

    if (kDebugMode) {
      print(event);
    }
  }*/
}
