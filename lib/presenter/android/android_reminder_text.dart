import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/bell/reminder_text.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';

class AndroidReminderText extends ReminderText {
  AndroidReminderText() : super();

  @protected
  AndroidReminderText.protectedCreating(
      String reminderText, List history) {
    innerHistoryOfReminderTexts = history;
    innerReminderText = reminderText;
  }

  String toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'reminderText': innerReminderText,
      'historyOfReminderTexts': innerHistoryOfReminderTexts
    };
    return jsonEncode(map);
  }

  static AndroidReminderText fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    String? androidReminderText = map['reminderText'];
    return AndroidReminderText.protectedCreating(
        map['reminderText'], map['historyOfReminderTexts']);
  }

  Future<bool> saveToStorageAsync() async {
    await LocalManager.initAsync();

    bool result = await LocalManager.writeToFile(
        LocalManager.reminderTextFilePath!, toJson());

    return result;
  }

  static Future<AndroidReminderText> loadFromStorageAsync() async {
    await LocalManager.initAsync();

    String? bellReminderTextJson =
        await LocalManager.readFile(LocalManager.reminderTextFilePath!);

    // load from file
    if (bellReminderTextJson != null) {
      try {
        return AndroidReminderText.fromJson(bellReminderTextJson);
      } catch (e) {
        await StorageLogger.logBackgroundAsync(
            'error in AndroidReminderText.loadFromStorageAsync() ${e.toString()}');
      }
    }

    // create new
    return AndroidReminderText();
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(Object other) {
    return other is AndroidReminderText && hashCode == other.hashCode;
  }

  @override
  String toString() {
    return "reminder text: $innerReminderText $innerHistoryOfReminderTexts";
  }
}
