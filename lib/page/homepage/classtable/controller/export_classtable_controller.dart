// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:jiffy/jiffy.dart';
import 'package:yidianshi/widget/classtable/classtable_constant.dart';
import 'partner_classtable_controller.dart';

/// Controller for handling class table export functionality
mixin ExportClassTableController on PartnerClassTableController {
  // Time slots for class periods (24-hour format)
  final List<String> time = [
    "08:30", "09:15",  // Period 1
    "09:25", "10:10",  // Period 2
    "10:30", "11:15",  // Period 3
    "11:25", "12:10",  // Period 4
    "14:00", "14:45",  // Period 5
    "14:55", "15:40",  // Period 6
    "16:00", "16:45",  // Period 7
    "16:55", "17:40",  // Period 8
    "19:00", "19:45",  // Period 9
    "19:55", "20:40",  // Period 10
    "20:50", "21:35",  // Period 11
  ];

  // iCalendar generation
  String get iCalenderStr {
    String toReturn = "BEGIN:VCALENDAR\nTZID:Asia/Shanghai\n";
    for (var i in timeArrangement) {
      String summary =
          "SUMMARY:${getClassDetail(timeArrangement.indexOf(i))}@${i.classroom ?? "待定"}\n";
      String description =
          "DESCRIPTION:课程名称：${getClassDetail(timeArrangement.indexOf(i)).name}; "
          "上课地点：${i.classroom ?? "待定"}\n";
      for (int j = 0; j < i.weekList.length; ++j) {
        if (!i.weekList[j]) {
          continue;
        }
        Jiffy day = Jiffy.parseFromDateTime(startDay).add(
          weeks: j,
          days: i.day - 1,
        );
        String vevent = "BEGIN:VEVENT\n$summary";
        List<String> startTime = time[(i.start - 1) * 2].split(":");
        List<String> stopTime = time[(i.stop - 1) * 2 + 1].split(":");
        vevent +=
            "DTSTART:${day.add(hours: int.parse(startTime[0]), minutes: int.parse(startTime[1])).format(pattern: 'yyyyMMddTHHmmss')}\n";
        vevent +=
            "DTEND:${day.add(hours: int.parse(stopTime[0]), minutes: int.parse(stopTime[1])).format(pattern: 'yyyyMMddTHHmmss')}\n";
        toReturn += "$vevent${description}END:VEVENT\n";
      }
    }
    return "${toReturn}END:VCALENDAR";
  }
}
