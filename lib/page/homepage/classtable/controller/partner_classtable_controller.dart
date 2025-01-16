// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/classtable.dart';
import 'package:yidianshi/model/xidian_ids/exam.dart';
import 'package:yidianshi/model/xidian_ids/experiment.dart';
import 'package:yidianshi/shared/utils/logger.dart';
import 'package:yidianshi/xd_api/base/network_session.dart';
import 'package:yidianshi/xd_api/tool/classtable_session.dart';
import 'base_classtable_controller.dart';

/// Controller for handling partner class table functionality
class PartnerClassTableController extends BaseClassTableController {
  // Reactive State
  final _isPartner = false.obs;
  final _partnerClass = Rxn<ClassTableData>();
  final _partnerSubjects = Rxn<List<Subject>>();
  final _partnerExperiment = Rxn<List<ExperimentData>>();
  final _partnerName = Rxn<String>();

  // Partner state getters
  bool get isPartner => _isPartner.value;
  bool get havePartner => _partnerClass.value != null && 
                         _partnerSubjects.value != null && 
                         _partnerExperiment.value != null;
  bool get haveClass => classDetail.isNotEmpty;
  String? get partnerName => _partnerName.value;

  // Override getters to include partner data
  @override
  List<ClassDetail> get classDetail => isPartner
      ? _partnerClass.value!.classDetail
      : super.classDetail;

  @override
  List<NotArrangementClassDetail> get notArranged => isPartner
      ? _partnerClass.value!.notArranged
      : super.notArranged;

  @override
  List<TimeArrangement> get timeArrangement => isPartner
      ? _partnerClass.value!.timeArrangement
      : super.timeArrangement;

  @override
  List<ClassChange> get classChange => isPartner
      ? _partnerClass.value!.classChanges
      : super.classChange;

  @override
  List<Subject> get subjects => isPartner 
      ? _partnerSubjects.value!
      : super.subjects;

  @override
  List<ExperimentData> get experiments => isPartner
      ? _partnerExperiment.value!
      : super.experiments;

  // Partner mode control
  set isPartner(bool value) {
    if (value && !havePartner) return;
    _isPartner.value = value;
  }

  // Partner data operations
  (String, ClassTableData, List<Subject>, List<ExperimentData>, bool)
      decodePartnerClass(String source) {
    final data = jsonDecode(source);
    var yearNotEqual = semesterCode.substring(0, 4).compareTo(
            data["classtable"]["semesterCode"].toString().substring(0, 4)) !=
        0;
    var lastNotEqual = semesterCode
            .substring(semesterCode.length - 1)
            .compareTo(data["classtable"]["semesterCode"].toString().substring(
                  data["classtable"]["semesterCode"].length - 1,
                )) !=
        0;
    if (yearNotEqual || lastNotEqual) {
      throw NotSameSemesterException(
        msg: "Not the same semester. This semester: $semesterCode. "
            "Input source: ${data["classtable"]["semesterCode"]}."
            "This partner classtable is going to be deleted.",
      );
    }
    return (
      data["name"] ?? "Sweetie",
      ClassTableData.fromJson(data["classtable"]),
      List.generate(
        data["exam"].length,
        (i) => Subject.fromJson(data["exam"][i]),
      ),
      List.generate(
        data["experiment"].length,
        (i) => ExperimentData.fromJson(data["experiment"][i]),
      ),
      true,
    );
  }

  void updatePartnerClass() {
    var file = File("${supportPath.path}/${ClassTableFile.partnerClassName}");
    if (!file.existsSync()) throw Exception("File not found.");
    final data = decodePartnerClass(file.readAsStringSync());
    _partnerName.value = data.$1;
    _partnerClass.value = data.$2;
    _partnerSubjects.value = data.$3;
    _partnerExperiment.value = data.$4;
    update();
  }

  void deletePartnerClass() {
    var file = File("${supportPath.path}/${ClassTableFile.partnerClassName}");
    if (!file.existsSync()) {
      throw Exception("File not found.");
    }
    file.deleteSync();
    _partnerClass.value = null;
    _partnerSubjects.value = null;
    _partnerExperiment.value = null;
    _isPartner.value = false;
    update();
  }

  // Partner class data generation
  String ercStr(String name) => jsonEncode({
        "name": name,
        "classtable": classTableControllermin.classTableData,
        "exam": examController.data.subject,
        "experiment": experimentController.data,
      });

  @override
  void onInit() {
    super.onInit();
    
    // Try to load partner class
    try {
      updatePartnerClass();
    } on NotSameSemesterException {
      deletePartnerClass();
    } on Exception {
      log.info("No partner classtable present...");
    }
  }

  PartnerClassTableController({
    required super.currentWeek,
  });
}
