// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/exam.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart' as base;

enum ExamStatus {
  cache,
  fetching,
  fetched,
  error,
}

class ExamControllers extends GetxController {
  final _examController = Get.find<base.ExamController>();
  
  ExamData get data => _examController.data;
  
  Rx<ExamStatus> get status {
    switch (_examController.status) {
      case base.ExamStatus.cache:
        return ExamStatus.cache.obs;
      case base.ExamStatus.fetching:
        return ExamStatus.fetching.obs;
      case base.ExamStatus.fetched:
        return ExamStatus.fetched.obs;
      case base.ExamStatus.error:
        return ExamStatus.error.obs;
      case base.ExamStatus.none:
        return ExamStatus.cache.obs;  // Default to cache when none
    }
  }
  List<Subject> get isDisQualified => _examController.isDisQualified;
  
  dynamic get error => _examController.error;

  List<Subject> isNotFinished(DateTime time) => _examController.isNotFinished(time);
  List<Subject> isFinished(DateTime time) => _examController.isFinished(time);
  
  @override
  void onInit() {
    super.onInit();
    // Additional initialization if needed
  }
}
