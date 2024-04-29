import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:landing_v3/ui/shared/testimonial_card.dart';
import 'package:landing_v3/ui/shared/testimonial_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class TestimonialsView extends StatelessWidget {
  final GlobalKey viewKey;
  const TestimonialsView({super.key, required this.viewKey});

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          CustomTitleWidget(
            text: "Testimonios",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 30),
          Wrap(
            children: [
              TestimonialCard(
                testimonialText: "Muy sencillo y fácil de usar",
                authorName: "Rest El Ahumado",
                authorDetails: "Gerente",
                authorImage:
                    const AssetImage("assets/Testimonios/bg_Tes01.jpeg"),
                rating: 5,
                onTap: () =>
                    _showTestimonial(context, "assets/Testimonios/Tes01.jpeg"),
              ),
              TestimonialCard(
                testimonialText: "Excelente!! Fácil y práctico",
                authorName: "Smoke House",
                authorDetails: "Jefe de Meseros",
                authorImage:
                    const AssetImage("assets/Testimonios/bg_Tes02.jpeg"),
                rating: 5,
                onTap: () =>
                    _showTestimonial(context, "assets/Testimonios/Tes02.jpeg"),
              ),
              TestimonialCard(
                testimonialText:
                    "Va excelente! Me gustaría que el color fuera personalizado",
                authorName: "Servicio De Catering",
                authorDetails: "Gerente General",
                authorImage:
                    const AssetImage("assets/Testimonios/bg_Tes03.jpeg"),
                rating: 5,
                onTap: () =>
                    _showTestimonial(context, "assets/Testimonios/Tes03.jpeg"),
              ),
              TestimonialCard(
                testimonialText:
                    "La verdad es que muy bien, ha tenido buena aceptación",
                authorName: "Rest Red Chicken",
                authorDetails: "Dueño",
                authorImage:
                    const AssetImage("assets/Testimonios/bg_Tes04.jpeg"),
                rating: 5,
                onTap: () =>
                    _showTestimonial(context, "assets/Testimonios/Tes04.jpeg"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const DownArrowAnimationWidget(),
        ],
      ),
    );
  }

  void _showTestimonial(BuildContext context, String imagePath) async {
    logImageZoomEvent(imagePath, context);
    showDialog(
      context: context,
      builder: (_) => TestimonialDialog(imagePath: imagePath),
    );
  }

  void logImageZoomEvent(String imagePath, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();
    String imageName = imagePath.split('/').last.split('.').first;

    EventDetails details =
        EventDetails(imageId: imagePath, linkLabel: imageName);

    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'defaultSessionId',
        eventType: 'ImageZoom',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    Provider.of<UserEventProvider>(context, listen: false).addEvent(event);
  }
}
