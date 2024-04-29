import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/ui/pages/document_viewer_page.dart';

class BuildFooterWidget extends StatelessWidget {
  const BuildFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
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
                        documentPath: 'lib/data/terms_conditions.json')));
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
    );
  }
}
