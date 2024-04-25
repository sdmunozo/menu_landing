import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PromotionalWidgetHeightProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '4uRest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}
