// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/exam.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart' as base;

class ExamControllers extends GetxController {
  final _examController = Get.find<base.ExamController>();
  
  ExamData get data => _examController.data;
  base.ExamStatus get status => _examController.status;
  List<Subject> get isDisQualified => _examController.isDisQualified;
  
  List<Subject> isNotFinished(DateTime time) => _examController.isNotFinished(time);
  
  @override
  void onInit() {
    super.onInit();
    // Additional initialization if needed
  }
}
