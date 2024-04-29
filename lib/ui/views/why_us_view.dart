import 'package:flutter/material.dart';
import 'package:landing_v3/ui/shared/box_point_widget.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';

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

class WhyUsView extends StatelessWidget {
  final GlobalKey viewKey;
  const WhyUsView({super.key, required this.viewKey});

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
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.7 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          CustomTitleWidget(
            text: "¿Por qué un Menú Digital?",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 30),
          Wrap(
            children: [
              BoxPointWidget(
                point: "Ahorro",
                text: 'Hace que los restaurantes reduzcan costos de impresión.',
                icon: Icons.print_disabled,
                maxWidth: maxWidth,
                constraints: constraints,
              ),
              BoxPointWidget(
                point: "Claridad",
                text: 'Los clientes prefieren menús claros y legibles.',
                icon: Icons.visibility,
                maxWidth: maxWidth,
                constraints: constraints,
              ),
              BoxPointWidget(
                point: "Digital",
                text: 'Los jóvenes optan por menús digitales.',
                icon: Icons.devices_other,
                maxWidth: maxWidth,
                constraints: constraints,
              ),
              BoxPointWidget(
                point: "Eficiencia",
                text:
                    'Las actualizaciones de menús digitales son rápidas y económicas.',
                icon: Icons.update,
                maxWidth: maxWidth,
                constraints: constraints,
              ),
              BoxPointWidget(
                point: "Rapidez",
                text:
                    'Con el menú digital solicita la actualización de tu menú en minutos.',
                icon: Icons.flash_on,
                maxWidth: maxWidth,
                constraints: constraints,
              ),
              BoxPointWidget(
                point: "Optimización",
                text: 'Permite que tus meseros puedan trabajar mejor.',
                icon: Icons.speed,
                maxWidth: maxWidth,
                constraints: constraints,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
