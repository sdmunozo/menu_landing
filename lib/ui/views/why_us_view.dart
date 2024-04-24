import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const maxWidth = 1000;
const cardMaxWidth = 300.0;
const cardMaxHeight = 120.0;

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.only(top: 20, bottom: 45.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: AutoSizeText(
                      "¿Por qué un Menú Digital?",
                      style: titleStyle(constraints),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                  ),
                  SizedBox(height: 20),
                  _BuildContent(),
                ],
              ),
            );
          },
        ),
      ),
    );
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
        List<Widget> cards = [
          _buildTextCard(
              '• Hace que los restaurantes reduzcan costos de impresión.',
              constraints),
          _buildTextCard(
              '• Los clientes prefieren menús claros y legibles.', constraints),
          _buildTextCard(
              '• Los jóvenes optan por menús digitales.', constraints),
          _buildTextCard(
              '• Actualizaciones de los menús impresos son tediosas y costosas.',
              constraints),
          _buildTextCard(
              '• Con el menú digital solicita la actualización de tu menú en minutos.',
              constraints),
          _buildTextCard(
              '• Permite que tus meseros puedan trabajar mejor.', constraints),
        ];

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: cards,
        );
      },
    );
  }

  Widget _buildTextCard(String text, BoxConstraints constraints) {
    return Card(
      elevation: 4,
      child: Container(
        width: cardMaxWidth,
        height: cardMaxHeight,
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: AutoSizeText(
          text,
          style: subtitleStyle(constraints),
          textAlign: TextAlign.center,
          minFontSize: 10,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
