import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/models/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class PromotionalWidget extends StatefulWidget {
  final GlobalKey widgetKey;

  const PromotionalWidget({super.key, required this.widgetKey});

  @override
  _PromotionalWidgetState createState() => _PromotionalWidgetState();

  double getWidgetHeight() {
    final RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}

class _PromotionalWidgetState extends State<PromotionalWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  late AnimationController _entryController;
  late Animation<double> _positionAnimation;

  Timer? _timer;
  Duration _duration = const Duration(hours: 25);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: const Color.fromRGBO(164, 53, 240, 1),
      end: const Color.fromRGBO(87, 35, 208, 1),
    ).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _positionAnimation = Tween<double>(begin: -300, end: 0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOut,
      ),
    );

    _entryController.forward();

    _loadTimerState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');

    return Stack(
      key: widget.widgetKey,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_controller, _positionAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  color: _colorAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5, left: 20, right: 20),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _BuildPromotionText(
                              hours: hours, minutes: minutes, seconds: seconds),
                          const BuildCallToAction()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('startTime');
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (startTime != null) {
      final passedTime = Duration(milliseconds: currentTime - startTime);
      final remainingTime = const Duration(hours: 25) - passedTime;
      if (remainingTime.inSeconds > 0) {
        setState(() {
          _duration = remainingTime;
        });
      } else {
        await prefs.setInt('startTime', currentTime);
        setState(() {
          _duration = const Duration(hours: 25);
        });
      }
    } else {
      await prefs.setInt('startTime', currentTime);
    }

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      if (_duration.inSeconds == 0) {
        timer.cancel();
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('startTime', currentTime);
        setState(() {
          _duration = const Duration(hours: 25);
        });
        startTimer();
      } else {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class BuildCallToAction extends StatelessWidget {
  const BuildCallToAction({super.key});

  Future<void> launchUrlLink(Uri url, BuildContext context) async {
    EventDetails details = EventDetails(
        linkDestination: url.toString(),
        linkLabel: 'Subscripción Anual - Banner');

    EventBuilder builder = EventBuilder(
      eventType: "ExternalLink",
      details: details,
    );

    Provider.of<UserEventProvider>(context, listen: false)
        .addEvent(builder.build());

    try {
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);

      if (!launched) {
        if (kDebugMode) {
          //print('No se pudo lanzar $url');
        }
      } else {
        if (kDebugMode) {
          //print('Enlace lanzado con éxito: $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        //print('Error al lanzar $url: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          launchUrlLink(
              Uri.parse('https://buy.stripe.com/aEU28aajdaZI6S4aEI'), context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text('Solicitar ahora'),
      ),
    );
  }
}

class _BuildPromotionText extends StatelessWidget {
  final String hours;
  final String minutes;
  final String seconds;

  const _BuildPromotionText({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Oferta para nuevos restaurantes ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "| Menús Digitales desde solo ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: "\$299 MX al mes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ". Haz clic en el botón para pagar ahora. ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Finaliza en $hours:$minutes:$seconds.",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionalWidget extends StatefulWidget {
  final GlobalKey widgetKey;

  const PromotionalWidget({super.key, required this.widgetKey});

  @override
  _PromotionalWidgetState createState() => _PromotionalWidgetState();

  double getWidgetHeight() {
    final RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}

class _PromotionalWidgetState extends State<PromotionalWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  late AnimationController
      _entryController; // Nuevo controlador para la animación de entrada
  late Animation<double> _positionAnimation; // Animación para la posición

  Timer? _timer;
  Duration _duration = const Duration(hours: 25);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: const Color.fromRGBO(164, 53, 240, 1),
      end: const Color.fromRGBO(87, 35, 208, 1),
    ).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);

    // Nuevo controlador para la animación de entrada
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Animación de posición para la entrada
    _positionAnimation = Tween<double>(begin: -300, end: 0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOut,
      ),
    );

    _entryController.forward(); // Inicia la animación de entrada

    _loadTimerState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');

    return Stack(
      key: widget.widgetKey,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_controller, _positionAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                  0,
                  _positionAnimation
                      .value), // Aplica la animación de desplazamiento vertical
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  color: _colorAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5, left: 20, right: 20),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _BuildPromotionText(
                              hours: hours, minutes: minutes, seconds: seconds),
                          const BuildCallToAction()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

/*
    return Stack(
      key: widget.widgetKey,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_controller, _positionAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                color: _colorAnimation.value,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5, left: 20, right: 20),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _BuildPromotionText(
                              hours: hours, minutes: minutes, seconds: seconds),
                          const BuildCallToAction()
                        ],
                      ),
                    )),
              ),
            );
          },
        ),
      ],
    );*/
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('startTime');
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (startTime != null) {
      final passedTime = Duration(milliseconds: currentTime - startTime);
      final remainingTime = const Duration(hours: 25) - passedTime;
      if (remainingTime.inSeconds > 0) {
        setState(() {
          _duration = remainingTime;
        });
      } else {
        await prefs.setInt('startTime', currentTime);
        setState(() {
          _duration = const Duration(hours: 25);
        });
      }
    } else {
      await prefs.setInt('startTime', currentTime);
    }

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      if (_duration.inSeconds == 0) {
        timer.cancel();
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('startTime', currentTime);
        setState(() {
          _duration = const Duration(hours: 25);
        });
        startTimer();
      } else {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class BuildCallToAction extends StatelessWidget {
  const BuildCallToAction({super.key});

  void launchUrlLink(Uri url, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    // Creando el objeto de detalles del evento
    EventDetails details = EventDetails(
        linkDestination: url.toString(),
        linkLabel: 'Subscripción Anual - Banner');

    // Creando el objeto del evento principal
    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'defaultSessionId',
        eventType: 'ExternalLink',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    if (kDebugMode) {
      print(event.toJson()); // Utiliza toJson para imprimir el evento
    }

    // Utilizando el Provider para manejar el estado del evento
    Provider.of<UserEventProvider>(context, listen: false).addEvent(event);

    try {
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        if (kDebugMode) {
          print('No se pudo lanzar $url');
        }
        // Considera enviar el evento al servidor incluso si el enlace no se pudo abrir
      } else {
        if (kDebugMode) {
          print('Enlace lanzado con éxito: $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al lanzar $url: $e');
      }
    }
  }

 */

/*
    return Stack(
      key: widget.widgetKey,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_controller, _positionAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                color: _colorAnimation.value,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5, left: 20, right: 20),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _BuildPromotionText(
                              hours: hours, minutes: minutes, seconds: seconds),
                          const BuildCallToAction()
                        ],
                      ),
                    )),
              ),
            );
          },
        ),
      ],
    );*/


/*
  void launchUrlLink(Uri url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    // Creando el objeto de detalles del evento
    EventDetails details = EventDetails(
        linkDestination: url.toString(),
        linkLabel: 'Subscripción Anual - Banner');

    // Creando el objeto del evento principal
    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'defaultSessionId',
        eventType: 'ExternalLink',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    if (kDebugMode) {
      print(event.toJson()); // Utiliza toJson para imprimir el evento
    }

    try {
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        if (kDebugMode) {
          print('No se pudo lanzar $url');
        }
        // Considera enviar el evento al servidor incluso si el enlace no se pudo abrir
      } else {
        if (kDebugMode) {
          print('Enlace lanzado con éxito: $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al lanzar $url: $e');
      }
    }
  }
*/
  /*

  void _launchUrl(Uri url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    var event = {
      "UserId": userId ?? 'defaultUserId',
      "SessionId": sessionId ?? 'defaultSessionId',
      "EventType": "ExternalLink",
      "EventTimestamp": eventTimestamp,
      "EventDetails": {
        "LinkDestination": url.toString(),
        "LinkLabel": 'Subscripción Anual - Banner'
      }
    };

    if (kDebugMode) {
      print(event);
    }

    if (!await launchUrl(url)) {
      if (kDebugMode) {
        //print('No se pudo lanzar $url');
      }
    }
  }
*/