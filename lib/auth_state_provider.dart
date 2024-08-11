import 'package:flutter/material.dart';

class AuthStateProvider extends ChangeNotifier {
  bool _ignoreAuthChange = false;

  bool get ignoreAuthChange => _ignoreAuthChange;

  void toggleIgnoreAuthChange() {
    _ignoreAuthChange = !_ignoreAuthChange;
    notifyListeners();
  }

  void setIgnoreAuthChange(bool value) {
    _ignoreAuthChange = value;
    notifyListeners();
  }
}