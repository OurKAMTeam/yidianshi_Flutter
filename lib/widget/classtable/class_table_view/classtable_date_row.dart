// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/widget/classtable/classtable_constant.dart';
import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';
import 'package:yidianshi/page/homepage/classtable/controller/classtable_state_controller.dart';

/// The index row of the class table, shows the index of the day and the week.
class ClassTableDateRow extends StatelessWidget {
  final BoxConstraints constraints;
  
  const ClassTableDateRow({
    super.key,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateList = ClassTableStateController.to.dateList;

    return SizedBox(
      height: 50,
      child: Row(children: [
        SizedBox(
          width: leftRow,
          child: Center(
            child: Text(
              FlutterI18n.translate(context, "class_table.week"),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        ...List.generate(
          7,
          (index) => WeekInfomation(
            time: dateList[index],
            constraints: constraints,
          ),
        ),
      ]),
    );
  }
}

/// The week index info, shows the day and the week.
class WeekInfomation extends StatelessWidget {
  final DateTime time;
  final BoxConstraints constraints;
  
  const WeekInfomation({
    super.key,
    required this.time,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    bool isToday =
        (time.month == DateTime.now().month && time.day == DateTime.now().day);
    BoxConstraints size = Get.find<ClassTableController>().constraints;
    return SizedBox(
      width: (size.maxWidth - leftRow) / 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getWeekString(context, time.weekday - 1),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            time.day.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isToday ? FontWeight.bold : null,
              color: isToday
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87,
            ),
          )
              .center()
              .constrained(
                width: 26,
                height: 20,
              )
              .decorated(
                color: isToday
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.transparent,
              )
              .clipRRect(all: 8),
        ],
      ),
    );
  }
}
