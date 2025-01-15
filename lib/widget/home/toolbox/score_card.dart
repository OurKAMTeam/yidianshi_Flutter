// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/widget/public_widget_all/toast.dart';
import 'package:yidianshi/xd_api/tool/score_session.dart';
import 'package:yidianshi/xd_api/base/ids_session.dart';
import 'package:yidianshi/widget/home/small_function_card.dart';
import 'package:get/get.dart';
import 'package:yidianshi/routes/app_pages.dart';
import 'package:yidianshi/routes/routes.dart';


class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallFunctionCard(
      onTap: () {
        if (offline && !ScoreSession.isCacheExist) {
          showToast(
            context: context,
            msg: FlutterI18n.translate(
              context,
              "score.score_info_card.failed",
            ),
          );
        } else {
            Get.toNamed(
              Routes.HOME + Routes.SCORE,
              preventDuplicates: true,
              id: null,
            );
        }
      },
      icon: Icons.grading_rounded,
      nameKey: "homepage.toolbox.score",
    );
  }
}
