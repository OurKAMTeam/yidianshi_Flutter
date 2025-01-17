// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/score.dart';
import 'package:yidianshi/widget/public_widget_all/column_choose_dialog.dart';
import 'package:yidianshi/widget/public_widget_all/empty_list_view.dart';
import 'package:yidianshi/widget/public_widget_all/re_x_card.dart';
import 'package:yidianshi/widget/score/score_compose_card.dart';
import 'package:yidianshi/shared/utils/preference.dart';
import 'score_controller.dart';

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
              ).toString(),
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
              ).toString()}: ${controller.scores.value[mark].credit}",
            ).expanded(flex: 2),
            Text(
              "${FlutterI18n.translate(
                context,
                "score.score_compose_card.gpa",
              ).toString()}: ${controller.scores.value[mark].gpa}",
            ).expanded(flex: 3),
            Text(
              "${FlutterI18n.translate(
                context,
                "score.score_compose_card.score",
              ).toString()}: ${controller.scores.value[mark].scoreStr}",
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
    final filteredScores = controller.filteredScores;

    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "score.score_page.title")),
        actions: [
          if (!getBool(Preference.role))
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () => controller.toggleSelectMode(),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          if (filteredScores.isEmpty)
            EmptyListView(
              text: FlutterI18n.translate(context, "score.score_page.no_record"),
              type: Type.reading,
            ).expanded()
          else
            _buildScoreList(filteredScores).expanded(),
        ],
      ),
      bottomNavigationBar: controller.isSelectMode.value
          ? _buildBottomBar(context)
          : null,
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: [
        TextField(
          controller: controller.searchController,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: FlutterI18n.translate(context, "score.score_page.search_hint"),
          ),
          onSubmitted: (value) {
            controller.searchText.value = value;
            controller.filterScores();
          },
        ).padding(bottom: 8),
        FilledButton(
          onPressed: () async {
            await showDialog<int>(
              context: context,
              builder: (context) => ColumnChooseDialog(
                chooseList: ["score.all_semester", ...controller.semester].toList(),
              ),
            ).then((value) {
              if (value != null) {
                controller.selectedSemester.value = ["", ...controller.semester].toList()[value];
              }
            });
          },
          child: Text(FlutterI18n.translate(
            context,
            "score.chosen_semester",
            translationParams: {
              "chosen": (controller.selectedSemester.value == ""
                  ? FlutterI18n.translate(
                      context,
                      "score.all_semester",
                    )
                  : controller.selectedSemester.value ?? "").toString(),
            },
          )),
        ).padding(right: 8),
        FilledButton(
          onPressed: () async {
            await showDialog<int>(
              context: context,
              builder: (context) => ColumnChooseDialog(
                chooseList: ["score.all_type", ...controller.statuses].toList(),
              ),
            ).then((value) {
              if (value != null) {
                controller.selectedStatus.value = ["", ...controller.statuses].toList()[value];
              }
            });
          },
          child: Text(FlutterI18n.translate(
            context,
            "score.chosen_type",
            translationParams: {
              "type": (controller.selectedStatus.value == ""
                  ? FlutterI18n.translate(
                      context,
                      "score.all_type",
                    )
                  : controller.selectedStatus.value ?? "").toString(),
            },
          )),
        ),
      ],
    ).padding(horizontal: 14, top: 8, bottom: 6)
     .constrained(maxWidth: 480);
  }

  Widget _buildScoreList(List<Score> scores) {
    return LayoutBuilder(
      builder: (context, constraints) => AlignedGridView.count(
        shrinkWrap: true,
        itemCount: scores.length,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        crossAxisCount: constraints.maxWidth ~/ 480,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) => _ScoreInfoCard(
          mark: scores[index].mark,
          isScoreChoice: controller.isSelected[scores[index].mark],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      height: 136,
      elevation: 5.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () => controller.setScoreChoiceState(ChoiceState.all),
                child: Text(FlutterI18n.translate(
                  context,
                  "score.score_page.select_all",
                ).toString()),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () => controller.setScoreChoiceState(ChoiceState.none),
                child: Text(FlutterI18n.translate(
                  context,
                  "score.score_page.select_nothing",
                ).toString()),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () => controller.setScoreChoiceState(ChoiceState.original),
                child: Text(FlutterI18n.translate(
                  context,
                  "score.score_page.reset_select",
                ).toString()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(controller.bottomInfo(context)),
              FloatingActionButton(
                elevation: 0.0,
                highlightElevation: 0.0,
                focusElevation: 0.0,
                disabledElevation: 0.0,
                onPressed: () => _showScoreInfoDialog(context),
                child: const Icon(Icons.panorama_fisheye),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showScoreInfoDialog(BuildContext context) async {
    await Get.dialog(
      AlertDialog(
        title: Text(FlutterI18n.translate(
          context,
          "score.score_choice.sum_dialog_title",
        ).toString()),
        content: Text(FlutterI18n.translate(
          context,
          "score.score_choice.sum_dialog_content",
        ).toString()),
        actions: [
          TextButton(
            child: Text(FlutterI18n.translate(context, "confirm").toString()),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}