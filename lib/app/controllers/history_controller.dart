import 'package:flutter/material.dart';
import 'package:pedro_downloads/app/services/shared_service.dart';

import '../models/history_model.dart';

class HistoryController extends ChangeNotifier {
  static final HistoryController instance = HistoryController();
  List<HistoryModel> historyList = [];

  Future<void> removeFromHistory(HistoryModel history) async {
    historyList.remove(history);
    await SharedService.instance.removeFromHistory(history);
    notifyListeners();
  }

  clearHistory() {
    historyList.clear();
    SharedService.instance.clearHistory();
    notifyListeners();
  }
  
  Future<void> addToHistory(HistoryModel history) async {
    historyList.add(history);
    await SharedService.instance.addToHistory(history);
    notifyListeners();
  }
}
