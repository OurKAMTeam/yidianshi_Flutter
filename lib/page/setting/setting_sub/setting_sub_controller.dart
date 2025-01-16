import 'dart:io';
import 'package:get/get.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/widget/home/info_widget/controller/controller.dart';
import 'package:yidianshi/widget/home/info_widget/classtable_card.dart';
import 'package:yidianshi/xd_api/tool/classtable_session.dart';
import 'package:yidianshi/xd_api/tool/score_session.dart';
import 'package:yidianshi/shared/shared.dart';
import 'package:restart_app/restart_app.dart';
import 'package:yidianshi/xd_api/base/network_session.dart';

class SettingSubController extends GetxController {
  // UI设置
  final Rx<int> currentBrightness = preference.getInt(preference.Preference.brightness).obs;
  final Rx<int> currentColor = preference.getInt(preference.Preference.color).obs;
  final Rx<bool> simplifiedClassTimeline = preference.getBool(preference.Preference.simplifiedClassTimeline).obs;
  final Rx<String> currentLocalization = preference.getString(preference.Preference.localization).obs;
  
  // 课表设置
  final Rx<bool> decorated = preference.getBool(preference.Preference.decorated).obs;
  final Rx<bool> decoration = preference.getBool(preference.Preference.decoration).obs;
  final Rx<int> swift = preference.getInt(preference.Preference.swift).obs;

  void updateBrightness(int value) async {
    await preference.setInt(preference.Preference.brightness, value);
    currentBrightness.value = value;
    ThemeController toChange = Get.put(ThemeController());
    toChange.onUpdate();
  }

  void updateSimplifiedClassTimeline(bool value) async {
    await preference.setBool(preference.Preference.simplifiedClassTimeline, value);
    simplifiedClassTimeline.value = value;
    ClassTableCard.reloadSettingsFromPref();
  }

  void updateDecorated(bool value) async {
    await preference.setBool(preference.Preference.decorated, value);
    decorated.value = value;
  }

  void clearUserClass() {
    var file = File("${supportPath.path}/${ClassTableFile.userDefinedClassName}");
    if (file.existsSync()) {
      file.deleteSync();
    }
    Get.find<ClassTableControllerMin>().updateClassTable();
  }

  void refreshClassTable() {
    Get.put(ClassTableControllerMin()).updateClassTable(isForce: true);
  }

  Future<void> clearCache() async {
    try {
      await NetworkSession().clearCookieJar();
    } on PathNotFoundException {
      log.debug("[setting][ClearAllCache]No cookies.");
    }
    _removeCache();
  }

  Future<void> logout() async {
    try {
      await NetworkSession().clearCookieJar();
    } catch (_) {}
    _removeAll();
    await preference.prefrenceClear();
    ThemeController toChange = Get.put(ThemeController());
    toChange.onUpdate();
    Restart.restartApp();
  }
}

void _removeCache() {
  for (var value in [
    ClassTableFile.schoolClassName,
    ExamController.examDataCacheName,
    ExperimentController.experimentCacheName,
    ScoreSession.scoreListCacheName
  ]) {
    var file = File("${supportPath.path}/$value");
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}

void _removeAll() {
  for (var value in [
    ClassTableFile.schoolClassName,
    ClassTableFile.userDefinedClassName,
    ClassTableFile.partnerClassName,
    ClassTableFile.decorationName,
    ExamController.examDataCacheName,
    ExperimentController.experimentCacheName,
    ScoreSession.scoreListCacheName
  ]) {
    var file = File("${supportPath.path}/$value");
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
