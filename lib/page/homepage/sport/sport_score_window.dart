// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
//import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:yidianshi/model/xidian_sport/score.dart';
import 'package:yidianshi/widget/public_widget_all/re_x_card.dart';
//import 'package:yidianshi/widget/public_widget_all/data_list.dart';
import 'sport_controller.dart';

class SportScoreWindow extends GetView<SportController> {
  const SportScoreWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: sheetMaxWidth),
        child: EasyRefresh.builder(
          controller: controller.scoreRefreshController,
          clipBehavior: Clip.none,
          header: const MaterialHeader(
            clamping: true,
            showBezierBackground: false,
            bezierBackgroundAnimation: false,
            bezierBackgroundBounce: false,
            springRebound: false,
          ),
          onRefresh: () async {
            await controller.getScore();
            controller.scoreRefreshController.finishRefresh();
            controller.scoreRefreshController.resetFooter();
          },
          refreshOnStart: true,
          childBuilder: (context, physics) => Obx(() {
            if (controller.sportScore.value.situation == null &&
                controller.sportScore.value.detail.isNotEmpty) {
              List<Widget> things = [
                ReXCard(
                  title: Text(FlutterI18n.translate(
                    context,
                    "sport.total_score",
                  )),
                  remaining: [
                    ReXCardRemaining(
                      controller.sportScore.value.total,
                      color: controller.sportScore.value.rank.contains("不")
                          ? Colors.red
                          : null,
                      isBold: true,
                    ),
                    ReXCardRemaining(
                      controller.sportScore.value.rank,
                      color: controller.sportScore.value.rank.contains("不")
                          ? Colors.red
                          : null,
                      isBold: controller.sportScore.value.rank.contains("不"),
                    )
                  ],
                  bottomRow: Text(
                    controller.sportScore.value.detail.substring(
                      0,
                      controller.sportScore.value.detail.indexOf("\\"),
                    ),
                  ),
                ),
              ];
              things.addAll(List<Widget>.generate(
                controller.sportScore.value.list.length,
                (index) => ScoreCard(score: controller.sportScore.value.list[index]),
              ).reversed);
              return DataList<Widget>(
                physics: physics,
                list: things,
                initFormula: (toUse) => toUse,
              );
            } else if (controller.sportScore.value.situation ==
                "sport.situation_fetching") {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: ReloadWidget(
                  function: () => controller.scoreRefreshController.callRefresh(),
                  errorStatus: controller.sportClass.value.situation != null
                      ? FlutterI18n.translate(
                          context,
                          "sport.situation_error",
                          translationParams: {
                            "situation": FlutterI18n.translate(
                              context,
                              controller.sportClass.value.situation ?? "",
                            )
                          },
                        )
                      : null,
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final SportScoreOfYear score;
  
  const ScoreCard({
    super.key,
    required this.score,
  });

  String unitToShow(String eval) {
    switch (eval) {
      case "优秀":
        return "90";
      case "良好":
        return "80";
      case "及格":
        return "60";
      case "不及格":
        return "0";
      default:
        return eval;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              score.year,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${FlutterI18n.translate(context, "sport.score")}: ${score.totalScore}",
                ),
                Text(
                  "${FlutterI18n.translate(context, "sport.rank")}: ${score.rank}",
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(score.gradeType),
          ],
        ),
      ),
    );
  }
}
