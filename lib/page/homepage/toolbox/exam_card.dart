// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/page/public_widget/toast.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:yidianshi/controller/exam_controller.dart';
import 'package:yidianshi/page/exam/exam_info_window.dart';
import 'package:yidianshi/page/homepage/refresh.dart';
import 'package:yidianshi/page/homepage/small_function_card.dart';
import 'package:yidianshi/page/public_widget/context_extension.dart';
import 'package:yidianshi/repository/xidian_ids/ids_session.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExamController>(
      builder: (c) => SmallFunctionCard(
        onTap: () async {
          if (c.status == ExamStatus.cache || c.status == ExamStatus.fetched) {
            context.pushReplacement(ExamInfoWindow(time: updateTime));
          } else if (c.status != ExamStatus.error) {
            showToast(
              context: context,
              msg: FlutterI18n.translate(
                context,
                "homepage.toolbox.exam_fetching",
              ),
            );
          } else if (offline) {
            showToast(
              context: context,
              msg: FlutterI18n.translate(
                context,
                "homepage.offline_mode",
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(FlutterI18n.translate(
                  context,
                  c.error.toString(),
                ).substring(
                  0,
                  min(
                    FlutterI18n.translate(
                      context,
                      c.error.toString(),
                    ).length,
                    120,
                  ),
                )),
              ),
            );
            showToast(
              context: context,
              msg: FlutterI18n.translate(
                context,
                "homepage.toolbox.exam_error",
              ),
            );
          }
        },
        icon: MingCuteIcons.mgc_calendar_line,
        nameKey: "homepage.toolbox.exam",
      ),
    );
  }
}
