// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'sport_controller.dart';
import 'sport_class_window.dart';
import 'sport_score_window.dart';

class SportWindow extends GetView<SportController> {
  const SportWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(
            context,
            "sport.title",
          )),
          bottom: TabBar(
            onTap: (index) => controller.currentIndex = index,
            tabs: [
              Tab(
                text: FlutterI18n.translate(
                  context,
                  "sport.test_score",
                ),
              ),
              Tab(
                text: FlutterI18n.translate(
                  context,
                  "sport.class_info",
                ),
              ),
            ],
          ),
        ),
        body: Obx(() => TabBarView(
          children: const [
            SportScoreWindow(),
            SportClassWindow(),
          ],
        )),
      ),
    );
  }
}
