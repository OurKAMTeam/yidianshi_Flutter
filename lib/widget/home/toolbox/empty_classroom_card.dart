// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/widget/public_widget_all/toast.dart';
import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:yidianshi/widget/public_widget_all/context_extension.dart';
import 'package:yidianshi/xd_api/base/ids_session.dart';
import 'package:yidianshi/page/empty_classroom/empty_classroom_window.dart';
import 'package:yidianshi/widget/home/small_function_card.dart';

class EmptyClassroomCard extends StatelessWidget {
  const EmptyClassroomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallFunctionCard(
      onTap: () async {
        if (offline) {
          showToast(
            context: context,
            msg: FlutterI18n.translate(
              context,
              "homepage.offline_mode",
            ),
          );
        } else {
          context.pushReplacement(const EmptyClassroomWindow());
        }
      },
      icon: MingCuteIcons.mgc_building_2_line,
      nameKey: "homepage.toolbox.empty_classroom",
    );
  }
}
