import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/ui/pages/document_viewer_page.dart';
import 'package:landing_v3/ui/shared/promotional_widget.dart';
import 'package:landing_v3/ui/views/faq_view.dart';
import 'package:landing_v3/ui/views/for_who_view.dart';
import 'package:landing_v3/ui/views/menu_screens_view.dart';
import 'package:landing_v3/ui/views/presentation_view.dart';
import 'package:landing_v3/ui/views/suscriptions_view.dart';
import 'package:landing_v3/ui/views/testimonials_view.dart';
import 'package:landing_v3/ui/views/trust_elements_view.dart';
import 'package:landing_v3/ui/views/why_us_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final GlobalKey promotionalWidgetKey = GlobalKey();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (promotionalWidgetKey.currentContext != null) {
        final RenderBox renderBox = promotionalWidgetKey.currentContext!
            .findRenderObject() as RenderBox;

        double promotionalWidgetHeight = renderBox.size.height;

        Provider.of<PromotionalWidgetHeightProvider>(context, listen: false)
            .setPromotionalWidgetHeight(promotionalWidgetHeight);
      }
    });

    return Scaffold(
      body: Column(
        children: [
          PromotionalWidget(widgetKey: promotionalWidgetKey),
          Expanded(
            child: SingleChildScrollView(
              child: _HomeBody(),
            ),
          )
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final paddingHeight = 100.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(246, 246, 246, 1),
      //color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            const PresentationView(),
            const MenuScreensView(),
            const ForWhoView(),
            const WhyUsView(),
            const SuscriptionsView(),
            const TestimonialsView(),
            const FAQView(),
            const TrustElementsView(),
            SizedBox(
              height: paddingHeight,
            ),
            RichText(
              textAlign: TextAlign.center, // Texto alineado al centro
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Política de Privacidad',
                    style: const TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DocumentViewer(
                                documentPath: 'lib/data/privacy_policy.json')));
                      },
                  ),
                  const TextSpan(
                    text: ' | ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Términos y Condiciones',
                    style: const TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DocumentViewer(
                                documentPath:
                                    'lib/data/terms_conditions.json')));
                      },
                  ),
                  const TextSpan(
                    text: ' | ',
                    style: TextStyle(color: Colors.black),
                  ),
                  const TextSpan(
                    text: '© 2024 4uRest Todos los derechos reservados.',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
