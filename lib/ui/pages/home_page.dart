import 'package:flutter/material.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/ui/shared/promotional_widget.dart';
import 'package:landing_v3/ui/views/for_who_view.dart';
import 'package:landing_v3/ui/views/presentation_view.dart';
import 'package:landing_v3/ui/views/testimonials_view.dart';
import 'package:landing_v3/ui/views/why_us_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final GlobalKey promotionalWidgetKey = GlobalKey();

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
      body: Container(
          child: Column(
        children: [
          PromotionalWidget(widgetKey: promotionalWidgetKey),
          Expanded(
            child: SingleChildScrollView(
              child: _HomeBody(),
            ),
          )
        ],
      )),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final paddingHeight = 100.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      //color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PresentationView(),
            SizedBox(
              height: paddingHeight,
            ),
            ForWhoView(),
            SizedBox(
              height: paddingHeight,
            ),
            WhyUsView(),
            SizedBox(
              height: paddingHeight,
            ),
            TestimonialsView(),
            SizedBox(
              height: paddingHeight,
            ),
          ],
        ),
      ),
    );
  }
}
