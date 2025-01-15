// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'empty_classroom_controller.dart';

class EmptyClassroomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmptyClassroomController>(() => EmptyClassroomController());
  }
}
