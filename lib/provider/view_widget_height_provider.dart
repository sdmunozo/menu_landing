import 'package:flutter/material.dart';

class ViewHeightProvider extends ChangeNotifier {
  final Map<String, double> _viewHeights = {};

  double getViewHeight(String key) => _viewHeights[key] ?? 0.0;

  void setViewHeight(String key, double height) {
    if (_viewHeights[key] != height) {
      _viewHeights[key] = height;
      notifyListeners();
    }
  }
}
