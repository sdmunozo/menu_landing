import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/faq.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const maxWidth = 1000.0;

class FAQView extends StatelessWidget {
  final GlobalKey viewKey;

  const FAQView({super.key, required this.viewKey});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        key: viewKey,
        children: [
          PointsWidget(constraints: constraints),
        ],
      );
    });
  }
}

class PointsWidget extends StatelessWidget {
  final BoxConstraints constraints;

  const PointsWidget({super.key, required this.constraints});

  void _logFAQEvent(String faqId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    // Creando el objeto de detalles del evento
    EventDetails details = EventDetails(
        faqId:
            faqId // Asegúrate de que 'faqId' es un campo definido en EventDetails
        );

    // Creando el objeto del evento principal
    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'defaultSessionId',
        eventType: 'FAQClick',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    if (kDebugMode) {
      //print(event.toJson()); // Utiliza toJson para imprimir el evento
    }

    // Imprimir mensaje después de lanzar la URL
    //print('Enviando eventos pendientes... FAQClick ${details.faqId}');
    Provider.of<UserEventProvider>(context, listen: false).addEvent(event);
  }

/*
  void _logFAQEvent(String faqId) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    var event = {
      "userId": userId ?? 'defaultUserId',
      "SessionId": sessionId ?? 'defaultSessionId',
      "EventType": "FAQClick",
      "EventTimestamp": eventTimestamp,
      "EventDetails": {"FAQId": faqId}
    };

    if (kDebugMode) {
      print(event);
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.4 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          CustomTitleWidget(
            text: "Preguntas Frecuentes",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 30),
          const Text(
            "Generales",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ),
          Wrap(
            children: faqsGeneral
                .map((faq) => Card(
                      child: ExpansionTile(
                        title: Text(faq['pregunta']!),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq['respuesta']!,
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            _logFAQEvent(faq['clave']!, context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            "Suscripción y Pagos",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ),
          Wrap(
            children: faqsSuscripcionPagos
                .map((faq) => Card(
                      child: ExpansionTile(
                        title: Text(faq['pregunta']!),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq['respuesta']!,
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            _logFAQEvent(faq['clave']!, context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            "Personalización y Actualizaciones",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ),
          Wrap(
            children: faqsPersonalizacionActualizaciones
                .map((faq) => Card(
                      child: ExpansionTile(
                        title: Text(faq['pregunta']!),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq['respuesta']!,
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            _logFAQEvent(faq['clave']!, context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            "Funcionalidades",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ),
          Wrap(
            children: faqsFuncionalidades
                .map((faq) => Card(
                      child: ExpansionTile(
                        title: Text(faq['pregunta']!),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq['respuesta']!,
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            _logFAQEvent(faq['clave']!, context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            "Soporte y Comunicación",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ),
          Wrap(
            children: faqsSoporteComunicacion
                .map((faq) => Card(
                      child: ExpansionTile(
                        title: Text(faq['pregunta']!),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq['respuesta']!,
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            _logFAQEvent(faq['clave']!, context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            "Tecnología y Optimización",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ),
          Wrap(
            children: faqsTecnologiaOptimizacion
                .map((faq) => Card(
                      child: ExpansionTile(
                        title: Text(faq['pregunta']!),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq['respuesta']!,
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            _logFAQEvent(faq['clave']!, context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          const DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
