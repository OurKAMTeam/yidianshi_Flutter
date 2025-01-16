// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'dart:math' as math;
import 'package:jiffy/jiffy.dart';
import 'package:yidianshi/widget/classtable/class_table_view/class_organized_data.dart';
import 'package:yidianshi/shared/common/themes/color_seed.dart';
import 'partner_classtable_controller.dart';

/// Controller for handling class arrangement and overlap calculation
mixin ArrangementClassTableController on PartnerClassTableController {
  bool _checkIsOverlapping(
    double eStart1,
    double eEnd1,
    double eStart2,
    double eEnd2,
  ) =>
      (eStart1 >= eStart2 && eStart1 < eEnd2) ||
      (eEnd1 > eStart2 && eEnd1 <= eEnd2) ||
      (eStart2 >= eStart1 && eStart2 < eEnd1) ||
      (eEnd2 > eStart1 && eEnd2 <= eEnd1);

  List<ClassOrgainzedData> getArrangement({
    required int weekIndex,
    required int dayIndex,
  }) {
    List<ClassOrgainzedData> events = [];

    // Add class arrangements
    for (final i in timeArrangement) {
      if (i.weekList.length > weekIndex &&
          i.weekList[weekIndex] &&
          i.day == dayIndex) {
        events.add(ClassOrgainzedData.fromTimeArrangement(
          i,
          colorList[i.index % colorList.length],
          getClassDetail(timeArrangement.indexOf(i)).name,
        ));
      }
    }

    // Add subjects
    for (final i in subjects) {
      if (i.startTime == null ||
          i.stopTime == null ||
          i.startTime!.isBefore(Jiffy.parseFromDateTime(startDay))) {
        continue;
      }

      int diff = i.startTime!
          .diff(Jiffy.parseFromDateTime(startDay), unit: Unit.day)
          .toInt();

      if (diff ~/ 7 == weekIndex && diff % 7 + 1 == dayIndex) {
        events.add(ClassOrgainzedData.fromSubject(
          colorList[subjects.indexOf(i) % colorList.length],
          i,
        ));
      }
    }

    // Add experiments
    for (final i in experiments) {
      int diff = Jiffy.parseFromDateTime(i.time[0])
          .diff(Jiffy.parseFromDateTime(startDay), unit: Unit.day)
          .toInt();

      if (diff ~/ 7 == weekIndex && diff % 7 + 1 == dayIndex) {
        events.add(ClassOrgainzedData.fromExperiment(
          colorList[experiments.indexOf(i) % colorList.length],
          i,
        ));
      }
    }

    // Sort and arrange events
    events.sort((a, b) => a.start.compareTo(b.start));
    List<ClassOrgainzedData> arrangedEvents = [];

    for (final event in events) {
      final startTime = event.start;
      final endTime = event.stop;

      var eventIndex = -1;
      final arrangeEventLen = arrangedEvents.length;

      for (var i = 0; i < arrangeEventLen; i++) {
        final arrangedEventStart = arrangedEvents[i].start;
        final arrangedEventEnd = arrangedEvents[i].stop;

        if (_checkIsOverlapping(
            arrangedEventStart, arrangedEventEnd, startTime, endTime)) {
          eventIndex = i;
          break;
        }
      }

      if (eventIndex == -1) {
        arrangedEvents.add(event);
      } else {
        final arrangedEventData = arrangedEvents[eventIndex];
        final arrangedEventStart = arrangedEventData.start;
        final arrangedEventEnd = arrangedEventData.stop;

        final startDuration = math.min(startTime, arrangedEventStart);
        final endDuration = math.max(endTime, arrangedEventEnd);

        bool shouldNew = (event.stop - event.start) >=
            (arrangedEventData.stop - arrangedEventData.start);

        final newEvent = ClassOrgainzedData(
          start: startDuration,
          stop: endDuration,
          data: [
            ...arrangedEventData.data,
            ...event.data,
          ],
          color: shouldNew ? event.color : arrangedEventData.color,
          name: shouldNew ? event.name : arrangedEventData.name,
          place: shouldNew ? event.place : arrangedEventData.place,
        );

        arrangedEvents[eventIndex] = newEvent;
      }
    }

    return arrangedEvents;
  }
}
