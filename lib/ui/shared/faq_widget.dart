import 'package:flutter/material.dart';

class FAQWidget extends StatelessWidget {
  final List<Map<String, String>> faqs;

  const FAQWidget({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: faqs
          .map((faq) => Card(
                child: ExpansionTile(
                  title: Text(faq['pregunta']!),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(faq['respuesta']!,
                          style: TextStyle(color: Colors.grey[600])),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
