// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';
import 'package:yidianshi/widget/classtable/classtable_constant.dart';
import 'package:yidianshi/widget/classtable/week_choice_view.dart';

class WeekSelector extends GetView<ClassTableController> {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height >= 500 ? topRowHeightBig : topRowHeightSmall,
      child: Container(
        padding: const EdgeInsets.only(top: 2, bottom: 4),
        child: PageView.builder(
          padEnds: false,
          controller: controller.rowController,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: controller.semesterLength,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: weekButtonHorizontalPadding,
              ),
              child: SizedBox(
                width: weekButtonWidth,
                child: Obx(() => Card(
                  color: Get.theme.highlightColor.withOpacity(
                    controller.chosenWeek == index ? 0.3 : 0.0,
                  ),
                  elevation: 0.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      if (!controller.isTopRowLocked.value) {
                        controller.chosenWeek = index;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: WeekChoiceView(index: index),
                    ),
                  ),
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}
