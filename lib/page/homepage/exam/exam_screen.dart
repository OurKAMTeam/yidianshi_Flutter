// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/widget/public_widget_all/empty_list_view.dart';
import 'package:yidianshi/widget/public_widget_all/timeline_widget/timeline_title.dart';
import 'package:yidianshi/widget/public_widget_all/timeline_widget/timeline_widget.dart';
import 'package:yidianshi/widget/public_widget_all/toast.dart';
import 'package:yidianshi/xd_api/base/ids_session.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart' as info_widget;
import 'exam_controller.dart';
import '../../../widget/exam/exam_info_card.dart';
import '../../../widget/exam/not_arranged_info.dart';

class ExamScreen extends GetView<ExamControllers> {
  final DateTime time;
  
  const ExamScreen({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    if (offline && controller.status == info_widget.ExamStatus.cache) {
      showToast(
        context: context,
        msg: FlutterI18n.translate(context, "exam.cache_hint"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "exam.title")),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_time),
            onPressed: () => Get.to(() => NoArrangedInfo(
              list: controller.data.toBeArranged,
            )),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (controller.status == info_widget.ExamStatus.cache || 
            controller.status == info_widget.ExamStatus.fetched) {
          if (controller.data.subject.isNotEmpty) {
            return TimelineWidget(
              isTitle: [
                true,
                false,
                true,
                false,
                if (controller.isDisQualified.isNotEmpty) ...[true, false],
              ],
              children: [
                TimelineTitle(
                  title: FlutterI18n.translate(context, "exam.not_finished"),
                ),
                Builder(builder: (context) {
                  final isNotFinished = controller.isNotFinished(time);
                  if (isNotFinished.isNotEmpty) {
                    return isNotFinished
                        .map((e) => ExamInfoCard(toUse: e))
                        .toList()
                        .toColumn();
                  } else {
                    return ExamInfoCard(
                      title: FlutterI18n.translate(context, "exam.all_finished"),
                    );
                  }
                }),
                if (controller.isDisQualified.isNotEmpty) ...[
                  TimelineTitle(
                    title: FlutterI18n.translate(context, "exam.unable_to_exam"),
                  ),
                  controller.isDisQualified
                      .map((e) => ExamInfoCard(toUse: e))
                      .toList()
                      .toColumn(),
                ],
              ],
            );
          }
          return EmptyListView(
            type: Type.reading,
            text: FlutterI18n.translate(context, "exam.no_exam"),
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
