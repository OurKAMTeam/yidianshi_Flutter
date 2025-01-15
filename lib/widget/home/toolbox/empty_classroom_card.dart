// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/routes/routes.dart';
import 'package:yidianshi/widget/home/small_function_card.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class EmptyClassroomCard extends StatelessWidget {
  const EmptyClassroomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallFunctionCard(
      onTap: () {
        Get.toNamed(
          Routes.HOME + Routes.EMPTY_CLASSROOM,
          preventDuplicates: true,
          id: null,
        );
      },
      icon: MingCuteIcons.mgc_building_2_line,
      nameKey: "homepage.toolbox.empty_classroom",
      //title: "empty_classroom.title",
      //iconData: Icons.meeting_room_outlined,
    );
  }
}
