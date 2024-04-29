import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class GlobalConfigProvider {
  static SharedPreferences? prefs;
  static String userId = '';
  static String sessionId = '';

  static Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();

    String? storedUserId = prefs!.getString('userId');
    if (storedUserId == null) {
      userId = const Uuid().v4();
      await prefs!.setString('userId', userId);
    } else {
      userId = storedUserId;
    }

    sessionId = const Uuid().v4();
    await prefs!.setString('sessionId', sessionId);
  }
}
