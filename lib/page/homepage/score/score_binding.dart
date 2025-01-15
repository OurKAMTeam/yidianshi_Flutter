// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'score_controller.dart';

class ScoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScoreController>(() => ScoreController());
  }
}
