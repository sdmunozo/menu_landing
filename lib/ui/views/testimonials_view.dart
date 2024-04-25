import 'package:flutter/material.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:landing_v3/ui/shared/testimonial_card.dart';

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
  const TestimonialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            color: Color.fromRGBO(246, 246, 246, 1),
            child: PointsWidget(constraints: constraints),
          ),
        ],
      );
    });
  }
}

class PointsWidget extends StatelessWidget {
  final BoxConstraints constraints;

  PointsWidget({required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                authorImage: AssetImage("assets/Testimonios/bg_Tes01.jpeg"),
                rating: 5,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Dialog(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Image.asset("assets/Testimonios/Tes01.jpeg",
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Testimonios de testimonials aquí
              TestimonialCard(
                testimonialText: "Excelente!! Fácil y práctico",
                authorName: "Smoke House",
                authorDetails: "Jefe de Meseros",
                authorImage: AssetImage("assets/Testimonios/bg_Tes02.jpeg"),
                rating: 5,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Dialog(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Image.asset("assets/Testimonios/Tes02.jpeg",
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  );
                },
              ),
              TestimonialCard(
                testimonialText:
                    "Va excelente! Me gustaría que el color fuera personalizado",
                authorName: "Servicio De Catering",
                authorDetails: "Gerente General",
                authorImage: AssetImage("assets/Testimonios/bg_Tes03.jpeg"),
                rating: 5,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Dialog(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Image.asset("assets/Testimonios/Tes03.jpeg",
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  );
                },
              ),
              TestimonialCard(
                testimonialText:
                    "La verdad es que muy bien, ha tenido buena aceptación",
                authorName: "Rest Red Chicken",
                authorDetails: "Dueño",
                authorImage: AssetImage("assets/Testimonios/bg_Tes04.jpeg"),
                rating: 5,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Dialog(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Image.asset("assets/Testimonios/Tes04.jpeg",
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
