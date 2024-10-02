import 'package:flutter/material.dart';
class HomeController {
  static final HomeController instance = HomeController();
  ValueNotifier<bool> showHistory = ValueNotifier<bool>(false);

  changeShowHistory() {
    showHistory.value = !showHistory.value;
  }
}
