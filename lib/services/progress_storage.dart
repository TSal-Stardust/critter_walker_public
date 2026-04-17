import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/companion.dart';

class ProgressStorage {
  static const String _rosterKey = 'companion_roster';

  Future<List<Companion>> loadRoster() async {
    final prefs = await SharedPreferences.getInstance();
    final rosterJson = prefs.getString(_rosterKey);

    if (rosterJson == null) {
      return [];
    }

    final decoded = jsonDecode(rosterJson) as List<dynamic>;

    return decoded
        .map((item) => Companion.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRoster(List<Companion> roster) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      roster.map((companion) => companion.toJson()).toList(),
    );
    await prefs.setString(_rosterKey, encoded);
  }
}
