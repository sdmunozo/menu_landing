import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/trust_elements_widget.dart';

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

class TrustElementsView extends StatelessWidget {
  const TrustElementsView({super.key});

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
            text: "¿Por qué 4uRest?",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 30),
          const Wrap(
            children: [
              TrustElementWidget(
                visualElement: Icons.store,
                text: '+12 años en la Industria',
                isIcon: true,
              ),
              TrustElementWidget(
                visualElement: 'assets/tools/4uRest-DM-3.png',
                text: '4uRest es una Marca Registrada',
                isIcon: false,
              ),
              TrustElementWidget(
                visualElement: FontAwesomeIcons.tiktok,
                text: '+9k Confian en 4uRest',
                isIcon: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
