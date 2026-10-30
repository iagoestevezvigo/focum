import 'dart:convert';

import 'package:focum/models/intention_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntentionRepository {
  static const String _entriesKey = 'focum.entries.v1';
  static const int _maxEntries = 300;

  Future<void> saveEntry(IntentionEntry entry) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final entries = preferences.getStringList(_entriesKey) ?? <String>[];
    entries.insert(0, jsonEncode(entry.toJson()));
    await preferences.setStringList(
      _entriesKey,
      entries.take(_maxEntries).toList(),
    );
  }

  Future<List<IntentionEntry>> loadEntries() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final entries = preferences.getStringList(_entriesKey) ?? <String>[];

    return entries
        .map(
          (raw) =>
              IntentionEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        )
        .toList();
  }
}
