import 'package:flutter/material.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:landing_v3/ui/shared/point_row_widget.dart';
import 'package:provider/provider.dart';

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

class MenuHighlightsView extends StatelessWidget {
  final GlobalKey viewKey;

  const MenuHighlightsView({super.key, required this.viewKey});

  @override
  Widget build(BuildContext context) {
    double promotionalHeight =
        Provider.of<PromotionalWidgetHeightProvider>(context).height;

    double screenHeight =
        MediaQuery.of(context).size.height - promotionalHeight;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        key: viewKey,
        children: [
          SizedBox(
            height: screenHeight,
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
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.4 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          CustomTitleWidget(
            text: "Impulsa tu Restaurante",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Vende más mostrando mejor tus platillos',
            icon: Icons.trending_up,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Ahorra dinero en impresiones',
            icon: Icons.attach_money,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Libera carga de trabajo a tus meseros',
            icon: Icons.group,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Marketing y promoción para tu restaurante',
            icon: Icons.campaign,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 20),
          const DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
