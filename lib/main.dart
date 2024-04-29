import 'package:flutter/material.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:landing_v3/provider/view_widget_height_provider.dart';
import 'package:provider/provider.dart';
import 'package:landing_v3/ui/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String userId = prefs.getString('userId') ?? const Uuid().v4();
  if (!prefs.containsKey('userId')) {
    await prefs.setString('userId', userId);
  }

  String sessionId = const Uuid().v4();
  await prefs.setString('sessionId', sessionId);

  runApp(MyApp(sessionId: sessionId, userId: userId));
}

class MyApp extends StatelessWidget {
  final String sessionId;
  final String userId;

  const MyApp({super.key, required this.sessionId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserEventProvider()), // Agregado aquí
        ChangeNotifierProvider(
            create: (_) => PromotionalWidgetHeightProvider()),
        ChangeNotifierProvider(create: (_) => ViewHeightProvider()),
        Provider<String>.value(value: sessionId),
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
