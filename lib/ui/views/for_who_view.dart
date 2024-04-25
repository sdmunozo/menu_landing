import 'package:auto_size_text/auto_size_text.dart';
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

class ForWhoView extends StatelessWidget {
  const ForWhoView({super.key});

  @override
  Widget build(BuildContext context) {
    double promotionalHeight =
        Provider.of<PromotionalWidgetHeightProvider>(context).height;

    double screenHeight =
        MediaQuery.of(context).size.height - promotionalHeight - 20;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            height: screenHeight,
            color: Color.fromRGBO(246, 246, 246, 1),
            child: PointsWidget(constraints: constraints),
          ),
        ],
      );
    });
  }
}

class _BuildContent extends StatelessWidget {
  const _BuildContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > maxWidth;
        List<Widget> textContainers = [
          if (isWide) Spacer(),
          _buildTextContainer(
              '• Restaurantes con variaciones de menú frecuentes.',
              constraints),
          SizedBox(width: 10, height: 10),
          _buildTextContainer(
              '• Restaurantes que necesitan vender más.', constraints),
          SizedBox(width: 10, height: 10),
          _buildTextContainer('• Restaurantes con menús amplios.', constraints),
          if (isWide) Spacer(),
        ];
        return isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: textContainers,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: textContainers,
              );
      },
    );
  }

  Widget _buildTextContainer(String text, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: constraints.maxWidth > maxWidth
            ? constraints.maxWidth / 3 - 20
            : null,
        alignment: Alignment.center,
        child: AutoSizeText(
          text,
          style: subtitleStyle(constraints),
          textAlign: TextAlign.center,
          minFontSize: 10,
          maxLines: 3,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}

class PointsWidget extends StatelessWidget {
  final BoxConstraints constraints;

  PointsWidget({required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.6 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          CustomTitleWidget(
            text: "¿Para quién es esto?",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Restaurantes con variaciones de menú frecuentes.',
            icon: Icons.change_circle_outlined,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "right",
          ),
          SizedBox(height: 10),
          PointRowWidget(
            text: 'Restaurantes que necesitan vender más.',
            icon: Icons.data_saver_off,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "right",
          ),
          SizedBox(height: 10),
          PointRowWidget(
            text: 'Restaurantes con menús amplios.',
            icon: Icons.menu_book_outlined,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "right",
          ),
          SizedBox(height: 20),
          DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
