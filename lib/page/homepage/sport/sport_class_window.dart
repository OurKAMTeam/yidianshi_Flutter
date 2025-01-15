// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_sport/sport_class.dart';
import 'package:yidianshi/widget/public_widget_all/empty_list_view.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:yidianshi/widget/public_widget_all/re_x_card.dart';
//import 'package:yidianshi/widget/public_widget_all/data_list.dart';
import 'sport_controller.dart';

class SportClassWindow extends GetView<SportController> {
  const SportClassWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: sheetMaxWidth),
        child: EasyRefresh(
          controller: controller.classRefreshController,
          clipBehavior: Clip.none,
          header: const MaterialHeader(
            clamping: true,
            showBezierBackground: false,
            bezierBackgroundAnimation: false,
            bezierBackgroundBounce: false,
            springRebound: false,
          ),
          onRefresh: () async {
            await controller.getClass();
            controller.classRefreshController.finishRefresh();
          },
          refreshOnStart: true,
          child: Obx(
            () {
              if (controller.sportClass.value.situation == null) {
                return controller.sportClass.value.items.isNotEmpty
                    ? DataList<Widget>(
                        list: controller.sportClass.value.items
                            .map((element) => SportClassCard(data: element))
                            .toList(),
                        initFormula: (toUse) => toUse,
                      )
                    : EmptyListView(
                        type: Type.defaultimg,
                        text: FlutterI18n.translate(
                          context,
                          "sport.empty_class_info",
                        ));
              } else if (controller.sportClass.value.situation ==
                  "sport.situation_fetching") {
                return const CircularProgressIndicator().center();
              } else {
                return ReloadWidget(
                  function: () => controller.classRefreshController.callRefresh(),
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
                ).center();
              }
            },
          ),
        ),
      ),
    );
  }
}

class SportClassCard extends StatelessWidget {
  final SportClassItem data;
  
  const SportClassCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    List<String> weekList = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    String timeWeek = FlutterI18n.translate(
      context,
      "weekday.${weekList[data.week - 1]}",
    );

    String timePlace = FlutterI18n.translate(
      context,
      "sport.from_to",
      translationParams: {
        "start": data.start.toString(),
        "end": data.stop.toString(),
      },
    );

    return ReXCard(
      title: Text(data.name),
      remaining: [],
      bottomRow: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(MingCuteIcons.mgc_time_line),
              const SizedBox(width: 8),
              Text("$timeWeek $timePlace"),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(MingCuteIcons.mgc_user_2_line),
              const SizedBox(width: 8),
              Text(data.teacher),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(MingCuteIcons.mgc_location_2_line),
              const SizedBox(width: 8),
              Text(data.place),
            ],
          ),
        ],
      ),
    );
  }
}
