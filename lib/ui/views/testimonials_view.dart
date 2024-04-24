import 'package:flutter/material.dart';
import 'package:landing_v3/ui/shared/testimonial_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

const maxWidth = 1000;

double responsiveFontSize(double baseSize, BoxConstraints constraints) {
  return constraints.maxWidth > maxWidth ? baseSize + 10 : baseSize;
}

TextStyle titleStyle(BoxConstraints constraints) => TextStyle(
      fontFamily: 'Helvetica',
      fontSize: responsiveFontSize(28, constraints),
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

class TestimonialsView extends StatelessWidget {
  final List<Map<String, dynamic>> testimonials = [
    {
      "text": "Muy sencillo y fácil de usar",
      "rating": 5,
      "name": "Rest El Ahumado",
      "authorDetails": "Gerente",
      "details": "assets/Testimonios/bg_Tes01.jpeg",
      "image": "assets/Testimonios/Tes01.png",
    },
    {
      "text": "Excelente!! Fácil y práctico",
      "rating": 5,
      "name": "Smoke House",
      "authorDetails": "Jefe de Meseros",
      "details": "assets/Testimonios/bg_Tes02.jpeg",
      "image": "assets/Testimonios/Tes02.png",
    },
    {
      "text": "Va excelente! Me gustaría que el color fuera personalizado",
      "rating": 5,
      "name": "Servicio De Catering",
      "authorDetails": "Gerente General",
      "details": "assets/Testimonios/bg_Tes03.jpeg",
      "image": "assets/Testimonios/Tes03.png",
    },
    {
      "text": "La verdad es que muy bien, ha tenido buena aceptación",
      "rating": 5,
      "name": "Rest Red Chicken",
      "authorDetails": "Dueño",
      "details": "assets/Testimonios/bg_Tes04.jpeg",
      "image": "assets/Testimonios/Tes04.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(top: 20, bottom: 45.0, left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AutoSizeText(
                  "TESTIMONIOS",
                  style: titleStyle(constraints),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  minFontSize: 10,
                ),
              ),
              SizedBox(height: 20),
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
                              child: Image.asset("assets/Testimonios/Tes01.png",
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
                              child: Image.asset("assets/Testimonios/Tes02.png",
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
                              child: Image.asset("assets/Testimonios/Tes03.png",
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
                              child: Image.asset("assets/Testimonios/Tes04.png",
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
