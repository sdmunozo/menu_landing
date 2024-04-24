import 'package:flutter/material.dart';
import 'package:landing_v3/ui/shared/promotional_widget.dart';
import 'package:landing_v3/ui/views/about_view.dart';
import 'package:landing_v3/ui/views/contact_view.dart';
import 'package:landing_v3/ui/views/for_who_view.dart';
import 'package:landing_v3/ui/views/home_view.dart';
import 'package:landing_v3/ui/views/presentation_view.dart';
import 'package:landing_v3/ui/views/testimonials_view.dart';
import 'package:landing_v3/ui/views/why_us_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          PromotionalWidget(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      child: Column(
        children: [
          //HomeView(),
          PresentationView(),
          ForWhoView(),
          WhyUsView(),
          TestimonialsView(),
        ],
      ),
    );
  }
}

/*
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            _HomeBody(),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: PromotionalWidget(),
                )),
          ],
        ),
      ),
    );
  }
}
 */
