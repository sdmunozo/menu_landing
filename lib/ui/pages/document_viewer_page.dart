import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentViewer extends StatelessWidget {
  final String documentPath;

  const DocumentViewer({super.key, required this.documentPath});

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
              body: Stack(
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight: 100.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(
                            data['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 16),
                          ),
                          centerTitle: true,
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
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
                          childCount: data['content'].length,
                        ),
                      ),
                    ],
                  ),
                  IgnorePointer(
                    child: Center(
                      child: Opacity(
                        opacity: 0.2,
                        child: Image.asset('assets/tools/4uRest-DM-3.png'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading document"));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
