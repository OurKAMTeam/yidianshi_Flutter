// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';
import 'package:yidianshi/widget/classtable/class_table_view/class_table_view.dart';

class ClassTableViewWidget extends GetView<ClassTableController> {
  const ClassTableViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: controller.pageController,
      onPageChanged: (value) {
        if (!controller.isTopRowLocked.value) {
          controller.chosenWeek = value;
        }
      },
      itemCount: controller.semesterLength,
      itemBuilder: (context, index) => LayoutBuilder(
        builder: (context, constraints) => ClassTableView(
          constraint: constraints,
          index: index,
        ),
      ),
    );
  }
}
