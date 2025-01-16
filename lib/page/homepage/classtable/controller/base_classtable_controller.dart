// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:yidianshi/widget/home/info_widget/controller/classtable_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/experiment_controller.dart';
import 'package:yidianshi/model/xidian_ids/classtable.dart';
import 'package:yidianshi/model/xidian_ids/exam.dart';
import 'package:yidianshi/model/xidian_ids/experiment.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;

/// Base controller for class table functionality
/// Handles basic data access and week selection
class BaseClassTableController extends GetxController {
  // Dependencies
  final ClassTableControllerMin classTableController = Get.find();
  final ExamController examController = Get.find();
  final ExperimentController experimentController = Get.find();

  // Static Data
  final int offset = preference.getInt(preference.Preference.swift);
  final int currentWeek;

  // Reactive State
  final _chosenWeek = 0.obs;

  // Getters for static data
  int get semesterLength => classTableController.classTableData.semesterLength;
  String get semesterCode => classTableController.classTableData.semesterCode;
  DateTime get startDay => Jiffy.parse(classTableController.classTableData.termStartDay).dateTime;

  // Getters for class data
  List<ClassDetail> get classDetail => classTableController.classTableData.classDetail;
  List<NotArrangementClassDetail> get notArranged => classTableController.classTableData.notArranged;
  List<TimeArrangement> get timeArrangement => classTableController.classTableData.timeArrangement;
  List<ClassChange> get classChange => classTableController.classTableData.classChanges;
  List<Subject> get subjects => examController.data.subject;
  List<ExperimentData> get experiments => experimentController.data;

  // Week selection
  int get chosenWeek => _chosenWeek.value;
  set chosenWeek(int week) {
    if (week != _chosenWeek.value) {
      _chosenWeek.value = week;
    }
  }

  // User defined class operations
  Future<void> addUserDefinedClass(
    ClassDetail classDetail,
    TimeArrangement timeArrangement,
  ) async {
    await classTableController.addUserDefinedClass(
      classDetail,
      timeArrangement,
    );
    update();
  }

  Future<void> editUserDefinedClass(
    TimeArrangement oldTimeArrangment,
    ClassDetail classDetail,
    TimeArrangement timeArrangement,
  ) async {
    await classTableController.editUserDefinedClass(
      oldTimeArrangment,
      classDetail,
      timeArrangement,
    );
    update();
  }

  Future<void> deleteUserDefinedClass(
    TimeArrangement timeArrangement,
  ) async {
    await classTableController.deleteUserDefinedClass(timeArrangement);
    update();
  }

  // Helper methods
  ClassDetail getClassDetail(int index) =>
      classTableController.classTableData.getClassDetail(timeArrangement[index]);

  @override
  void onInit() {
    super.onInit();
    
    // Initialize chosen week
    if (currentWeek < 0) {
      _chosenWeek.value = 0;
    } else if (currentWeek >= semesterLength) {
      _chosenWeek.value = semesterLength - 1;
    } else {
      _chosenWeek.value = currentWeek;
    }
  }

  BaseClassTableController({
    required this.currentWeek,
  });
}
