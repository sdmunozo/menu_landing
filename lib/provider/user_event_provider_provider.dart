import 'package:flutter/material.dart';
import 'package:landing_v3/api/api_4uRest.dart';
import 'package:landing_v3/models/landing_user_event_model.dart';

class UserEventProvider with ChangeNotifier {
  final List<LandingUserEventModel> _events = [];

  List<LandingUserEventModel> get events => _events;

  void addEvent(LandingUserEventModel event) {
    _events.clear();
    _events.add(event);
    notifyListeners();
    sendEvents();
  }

  Future<void> sendEvents() async {
    try {
      for (LandingUserEventModel event in _events) {
        await Api4uRest.httpPost('/langind/create', event.toJson());
      }
      _events.clear();
      notifyListeners();
    } catch (e) {
      //print('Error al enviar eventos: $e');
    }
  }
}
