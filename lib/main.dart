import 'package:flutter/material.dart';
import 'package:pedro_downloads/app/controllers/history_controller.dart';
import 'package:pedro_downloads/app/my_app.dart';
import 'package:pedro_downloads/app/services/shared_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedService.instance.prefs = await SharedPreferences.getInstance();
  HistoryController.instance.historyList = SharedService.instance.getHistory();
  runApp(const MyApp());
}
