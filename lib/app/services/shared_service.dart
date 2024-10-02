import 'package:pedro_downloads/app/core/shared_keys.dart';
import 'package:pedro_downloads/app/models/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static final SharedService instance = SharedService();
  late SharedPreferences prefs;

  List<HistoryModel> getHistory() {
    try {
      var list = prefs.getStringList(SharedKeys.historyKey) ?? [];
      return list.map((e) => HistoryModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addToHistory(HistoryModel history) async {
    var list = prefs.getStringList(SharedKeys.historyKey) ?? [];
    list.add(history.toJson());
    await prefs.setStringList('history', list);
  }

  Future<void> clearHistory() async {
    await prefs.remove(SharedKeys.historyKey);
  }

  Future<void> removeFromHistory(HistoryModel history) async {
    var list = prefs.getStringList(SharedKeys.historyKey) ?? [];
    list.remove(history.toJson());
    await prefs.setStringList(SharedKeys.historyKey, list);
  }
}
