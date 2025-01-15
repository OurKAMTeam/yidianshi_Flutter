// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'school_card_controller.dart';

class SchoolCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SchoolCardController());
  }
}
