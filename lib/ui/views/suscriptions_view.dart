import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/trust_elements_widget.dart';
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
  const SuscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            color: const Color.fromRGBO(246, 246, 246, 1),
            child: PointsWidget(constraints: constraints),
          ),
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
          const SizedBox(height: 30),
          const Wrap(
            children: [
              SubscriptionWidget(
                name: 'Mensual',
                pricePerMonth: '399',
                subscriptionLink: 'https://buy.stripe.com/4gwfZ0eztgk24JWcMM',
              ),
              SubscriptionWidget(
                name: 'Semestral',
                pricePerMonth: '332.5',
                subscriptionLink: 'https://buy.stripe.com/4gw9ACajd8RAccoeUV',
                period: 6,
                pricePerPeriod: '1995',
                monthsSaved: '1',
              ),
              SubscriptionWidget(
                name: 'Anual',
                pricePerMonth: '299.25',
                subscriptionLink: 'https://buy.stripe.com/00g4gicrld7Q2BOcMO',
                period: 12,
                pricePerPeriod: '3591',
                monthsSaved: '3',
              ),
            ],
          )
        ],
      ),
    );
  }
}
