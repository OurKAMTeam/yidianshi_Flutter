// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/exam/exam_controller.dart';

class ExamBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamControllers>(() => ExamControllers());
  }
}
