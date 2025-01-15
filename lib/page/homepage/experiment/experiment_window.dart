// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/page/homepage/experiment/experiment_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/experiment_controller.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:yidianshi/widget/public_widget_all/timeline_widget/timeline_title.dart';
import 'package:yidianshi/widget/public_widget_all/timeline_widget/timeline_widget.dart';
import '../../../widget/experiment/experiment_info_card.dart';

class ExperimentWindow extends GetView<ExperimentPageController> {
  const ExperimentWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(
            context,
            "experiment.title",
          ),
        ),
      ),
      body: Obx(() {
        if (controller.status.value == ExperimentStatus.fetched ||
            controller.status.value == ExperimentStatus.cache) {
          var doing = controller.getDoing();
          var unDone = controller.getUnDone();
          var done = controller.getDone();
          return TimelineWidget(
            isTitle: [
              if (doing.isNotEmpty) ...[
                true,
                false,
              ],
              true,
              false,
              true,
              false,
              false
            ],
            children: [
              if (doing.isNotEmpty) ...[
                TimelineTitle(
                  title: FlutterI18n.translate(
                    context,
                    "experiment.ongoing",
                  ),
                ),
                Column(
                  children: List.generate(
                    doing.length,
                    (index) => ExperimentInfoCard(
                      data: doing[index],
                    ),
                  ),
                ),
              ],
              TimelineTitle(
                title: FlutterI18n.translate(
                  context,
                  "experiment.not_finished",
                ),
              ),
              unDone.isNotEmpty
                  ? Column(
                      children: List.generate(
                        unDone.length,
                        (index) => ExperimentInfoCard(
                          data: unDone[index],
                        ),
                      ),
                    )
                  : TimelineTitle(
                      title: FlutterI18n.translate(
                        context,
                        "experiment.all_finished",
                      ),
                    ),
              TimelineTitle(
                title: FlutterI18n.translate(
                  context,
                  "experiment.finished",
                ),
              ),
              ExperimentInfoCard(
                title: FlutterI18n.translate(
                  context,
                  "experiment.score_sum",
                  translationParams: {
                    "sum": controller.sum.toString(),
                  },
                ),
              ),
              done.isNotEmpty
                  ? Column(
                      children: List.generate(
                        done.length,
                        (index) => ExperimentInfoCard(
                          data: done[index],
                        ),
                      ),
                    )
                  : TimelineTitle(
                      title: FlutterI18n.translate(
                        context,
                        "experiment.none_finished",
                      ),
                    ),
            ],
          ).safeArea();
        } else if (controller.status.value == ExperimentStatus.error) {
          return ReloadWidget(
            function: controller.reload,
            errorStatus: FlutterI18n.translate(
              context,
              controller.error,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
