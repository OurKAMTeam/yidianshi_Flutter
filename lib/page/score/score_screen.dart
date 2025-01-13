// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/widget/public_widget_all/column_choose_dialog.dart';
import 'package:yidianshi/widget/public_widget_all/empty_list_view.dart';
import 'package:yidianshi/widget/public_widget_all/re_x_card.dart';
import 'package:yidianshi/widget/score/score_compose_card.dart';
import 'package:yidianshi/shared/utils/preference.dart';
import 'score_controller.dart';
import 'score_statics.dart';

class _ScoreInfoCard extends GetView<ScoreController> {
  final int mark;
  final bool isScoreChoice;

  const _ScoreInfoCard({
    required this.mark,
    this.isScoreChoice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        if (controller.isSelectMode.value) {
          if (isScoreChoice) {
            controller.setScoreChoiceFromIndex(mark);
          } else {
            controller.setScoreChoiceFromIndex(mark);
          }
        } else if (!getBool(Preference.role)) {
          showModalBottomSheet(
            context: context,
            builder: (context) => ScoreComposeCard(
              score: controller.scores.value[mark],
              detail: controller.scoreSession.getDetail(
                controller.scores.value[mark].classID,
                controller.scores.value[mark].semesterCode,
              ),
            ),
          );
        }
      },
      child: ReXCard(
        opacity: controller.getCardOpacity(mark, isScoreChoice),
        title: Text.rich(TextSpan(children: [
          if (controller.scores.value[mark].scoreStatus != "初修")
            TextSpan(text: "${controller.scores.value[mark].scoreStatus} "),
          if (controller.scores.value[mark].isPassed == false)
            TextSpan(
              text: FlutterI18n.translate(
                context,
                "score.score_info_card.failed",
              ),
            ),
          TextSpan(text: controller.scores.value[mark].name)
        ])),
        remaining: [
          ReXCardRemaining(controller.scores.value[mark].classStatus),
        ],
        bottomRow: DefaultTextStyle(
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          child: [
            Text(
              "${FlutterI18n.translate(
                context,
                "score.score_compose_card.credit",
              )}: ${controller.scores.value[mark].credit}",
            ).expanded(flex: 2),
            Text(
              "${FlutterI18n.translate(
                context,
                "score.score_compose_card.gpa",
              )}: ${controller.scores.value[mark].gpa}",
            ).expanded(flex: 3),
            Text(
              "${FlutterI18n.translate(
                context,
                "score.score_compose_card.score",
              )}: ${controller.scores.value[mark].scoreStr}",
            ).expanded(flex: 3),
          ].toRow(),
        ),
      ),
    ));
  }
}

class ScoreScreen extends GetView<ScoreController> {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Get.back),
        title: Text(FlutterI18n.translate(context, "score.title")),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showScoreInfoDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value!),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: Text(FlutterI18n.translate(context, "retry")),
                ),
              ],
            ),
          );
        }

        if (controller.scores.value.isEmpty) {
          return EmptyListView(
            type: Type.defaultimg,
            text: FlutterI18n.translate(context, "score.no_score"),
          );
        }

        return Column(
          children: [
            _buildFilterSection(context),
            Expanded(
              child: _buildScoreList(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: FlutterI18n.translate(context, "score.search"),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
              controller.searchText.value = value;
              controller.filterScores();
            },
          ).padding(bottom: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    final value = await Get.dialog<String>(
                      ColumnChooseDialog(
                        chooseList: ["score.all_semester", ...controller.semester],
                      ),
                    );
                    if (value != null) {
                      controller.selectedSemester.value = value;
                      controller.filterScores();
                    }
                  },
                  child: Text(FlutterI18n.translate(
                    context,
                    "score.semester",
                  )),
                ),
              ).padding(right: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    final value = await Get.dialog<String>(
                      ColumnChooseDialog(
                        chooseList: ["score.all_type", ...controller.statuses],
                      ),
                    );
                    if (value != null) {
                      controller.selectedStatus.value = value;
                      controller.filterScores();
                    }
                  },
                  child: Text(FlutterI18n.translate(
                    context,
                    "score.type",
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreList(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 1,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(4),
      itemCount: controller.scores.value.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ScoreStatics(
            avgScore: controller.evalAvg(true),
            avgGPA: controller.evalAvg(true, isGPA: true),
            selectedAvgScore: controller.evalAvg(false),
            selectedAvgGPA: controller.evalAvg(false, isGPA: true),
            selectedCredit: controller.evalCredit(false),
            totalCredit: controller.evalCredit(true),
          );
        }
        final scoreIndex = index - 1;
        return Obx(() => _ScoreInfoCard(
          mark: scoreIndex,
          isScoreChoice: controller.isSelectMode.value,
        ));
      },
    );
  }

  Future<void> _showScoreInfoDialog(BuildContext context) async {
    await Get.dialog(
      AlertDialog(
        title: Text(FlutterI18n.translate(
          context,
          "score.score_choice.sum_dialog_title",
        )),
        content: Text(FlutterI18n.translate(
          context,
          "score.score_choice.sum_dialog_content",
        )),
        actions: [
          TextButton(
            child: Text(FlutterI18n.translate(context, "confirm")),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
