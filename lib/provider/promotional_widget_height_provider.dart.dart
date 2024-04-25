import 'package:flutter/material.dart';

class PromotionalWidgetHeightProvider extends ChangeNotifier {
  double _height = 0;

  double get height => _height;

  void setPromotionalWidgetHeight(double height) {
    _height = height;
    notifyListeners();
  }
}
