// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/widget/public_widget_all/toast.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart';
import 'package:yidianshi/routes/routes.dart';
import 'package:yidianshi/widget/home/small_function_card.dart';
import 'package:yidianshi/xd_api/base/ids_session.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExamController>(
      builder: (c) => SmallFunctionCard(
        onTap: () async {
          if (c.status == ExamStatus.cache || c.status == ExamStatus.fetched) {
            Get.toNamed(
              Routes.HOME + Routes.EXAM,
              preventDuplicates: true,
              id: null,
            );
            //context.pushReplacement(ExamInfoWindow(time: updateTime));
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
