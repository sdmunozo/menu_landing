import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentViewer extends StatelessWidget {
  final String documentPath;

  DocumentViewer({required this.documentPath});

  Future<Map<String, dynamic>> loadDocument() async {
    final jsonString = await rootBundle.loadString(documentPath);
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDocument(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                title: Text(data['title']),
              ),
              body: ListView.builder(
                itemCount: data['content'].length,
                itemBuilder: (context, index) {
                  final content = data['content'][index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      content['text'],
                      style: TextStyle(
                        fontWeight: content['type'] == 'bold'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error loading document");
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
