import 'package:flutter/material.dart';
import 'package:landing_v3/data/faq.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:landing_v3/ui/shared/promotional_widget.dart';

const maxWidth = 1000.0;

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            color: Color.fromRGBO(246, 246, 246, 1),
            child: PointsWidget(constraints: constraints),
          ),
        ],
      );
    });
  }
}

class PointsWidget extends StatelessWidget {
  final BoxConstraints constraints;

  PointsWidget({required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
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
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          Text(
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
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          Text(
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
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          Text(
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
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          Text(
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
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
          Text(
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
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
