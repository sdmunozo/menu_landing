import 'package:flutter/material.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:landing_v3/ui/shared/type_suscription_widget.dart';

const maxWidth = 1000.0;

double responsiveFontSize(double baseSize, BoxConstraints constraints) {
  return constraints.maxWidth > maxWidth ? baseSize + 10 : baseSize;
}

TextStyle subtitleStyle(BoxConstraints constraints) => TextStyle(
      fontFamily: 'Helvetica',
      fontSize: responsiveFontSize(24, constraints),
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

TextStyle titleStyle(BoxConstraints constraints) => TextStyle(
      fontFamily: 'Helvetica',
      fontSize: responsiveFontSize(28, constraints),
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

class SuscriptionsView extends StatelessWidget {
  final GlobalKey viewKey;
  const SuscriptionsView({super.key, required this.viewKey});

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.8 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 20),
          CustomTitleWidget(
            text: "Suscríbete y potencia tu Restaurante",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 20),
          const Wrap(
            children: [
              SubscriptionWidget(
                  name: 'Mensual',
                  pricePerMonth: '399',
                  subscriptionLink: 'https://buy.stripe.com/14k7sufDxc3M1xK6ot',
                  color: Color(0XFF7ABD9B),
                  linkLabel: 'Subscripción Mensual - Section'),
              SubscriptionWidget(
                  name: 'Semestral',
                  pricePerMonth: '332',
                  subscriptionLink: 'https://buy.stripe.com/6oEaEG2QL3xg1xKaEH',
                  period: 6,
                  pricePerPeriod: '1992',
                  monthsSaved: '1',
                  color: Color(0XFF3B8686),
                  linkLabel: 'Subscripción Semestral - Section'),
              SubscriptionWidget(
                  name: 'Anual',
                  pricePerMonth: '299',
                  subscriptionLink: 'https://buy.stripe.com/aEU28aajdaZI6S4aEI',
                  period: 12,
                  pricePerPeriod: '3588',
                  monthsSaved: '3',
                  color: Color(0XFF0A486B),
                  linkLabel: 'Subscripción Anual - Section'),
            ],
          ),
          const SizedBox(height: 20),
          const Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Todas las suscripciones incluyen",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Captura inicial del Menú Digital."),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.update, color: Colors.blue),
                  SizedBox(width: 10),
                  Text("Actualizaciones ilimitadas sin costo extra."),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.support_agent, color: Colors.orange),
                  SizedBox(width: 10),
                  Text("Soporte técnico directo por WhatsApp."),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.new_releases, color: Colors.purple),
                  SizedBox(width: 10),
                  Text("Acceso a nuevas funcionalidades mensuales."),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.data_saver_off, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Optimización para bajo consumo de datos."),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          const DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
