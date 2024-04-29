import 'package:flutter/material.dart';
import 'package:landing_v3/data/faq.dart';
import 'package:landing_v3/models/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:provider/provider.dart';

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

  void _logFAQEvent(String faqId, BuildContext context) {
    EventDetails details = EventDetails(faqId: faqId);

    EventBuilder builder = EventBuilder(
      eventType: "FAQClick",
      details: details,
    );

    Provider.of<UserEventProvider>(context, listen: false)
        .addEvent(builder.build());
  }

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
