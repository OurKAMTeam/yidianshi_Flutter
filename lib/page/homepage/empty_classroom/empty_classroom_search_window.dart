// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/empty_classroom.dart';
import 'package:yidianshi/xd_api/base/network_session.dart';
import 'package:yidianshi/xd_api/tool/empty_classroom_session.dart';

class EmptyClassroomSearchWindow extends StatefulWidget {
  final List<EmptyClassroomPlace> places;

  const EmptyClassroomSearchWindow({
    super.key,
    required this.places,
  });

  @override
  State<EmptyClassroomSearchWindow> createState() =>
      _EmptyClassroomSearchWindowState();
}

class _EmptyClassroomSearchWindowState
    extends State<EmptyClassroomSearchWindow> {
  final TextEditingController text = TextEditingController();
  final RxList<EmptyClassroomData> fetchedData = <EmptyClassroomData>[].obs;
  final Rx<EmptyClassroomPlace> chosen = EmptyClassroomPlace(name: '', code: '').obs;
  final Rx<DateTime> time = DateTime.now().obs;
  final Rx<SessionState> state = SessionState.none.obs;

  late ColorScheme colorScheme;
  String semesterCode =
      "2023-2024"; // Hardcoded semester code for demonstration purposes

  List<EmptyClassroomData> get data {
    List<EmptyClassroomData> toReturn = [];
    for (var i in fetchedData) {
      if (i.name.contains(text.text)) toReturn.add(i);
    }
    return toReturn;
  }

  void updateData() async {
    try {
      state.value = SessionState.fetching;
      fetchedData.clear();
      int startYear = int.parse(semesterCode.substring(0, 4));
      fetchedData.addAll(await EmptyClassroomSession().searchData(
        buildingCode: chosen.value.code,
        date: Jiffy.parseFromDateTime(time.value).format(pattern: "yyyy-MM-dd"),
        semesterRange: "$startYear-${startYear + 1}",
        semesterPart: semesterCode[semesterCode.length - 1],
      ));
      state.value = SessionState.fetched;
    } catch (e, s) {
      state.value = SessionState.error;
      print("Error occured while fetching empty classroom.");
    }
  }

  @override
  void initState() {
    EmptyClassroomPlace toGet = widget.places.first;
    chosen.value = toGet;
    updateData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    colorScheme = Theme.of(context).colorScheme;
    super.didChangeDependencies();
  }

  Widget getIcon(bool isUsed, {int? index}) => Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isUsed
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: index != null
            ? Text(
                index.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: isUsed
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ).center()
            : null,
      ).decorated(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(6),
      );

  void chooseBuilding() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(
                widget.places.length,
                (index) {
                  return RadioListTile<EmptyClassroomPlace>(
                    title: Text(widget.places[index].name),
                    value: widget.places[index],
                    groupValue: chosen.value,
                    onChanged: (EmptyClassroomPlace? value) {
                      if (value != null) {
                        chosen.value = value;
                        updateData();
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          [
            TextField(
              controller: text,
              autofocus: false,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: FlutterI18n.translate(
                  context,
                  "empty_classroom.search_hint",
                ),
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onSubmitted: (String text) => setState(() {}),
            ).padding(bottom: 8),
            [
              [
                FilledButton(
                  onPressed: () async {
                    await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarDatePicker2WithActionButtonsConfig(
                        calendarType: CalendarDatePicker2Type.single,
                      ),
                      dialogSize: const Size(325, 400),
                      value: [time.value],
                    ).then((value) {
                      if (value?.length == 1 && value?[0] != null) {
                        time.value = value![0]!;
                        updateData();
                      }
                    });
                  },
                  child: Text(FlutterI18n.translate(
                    context,
                    "empty_classroom.date",
                    translationParams: {
                      "date": Jiffy.parseFromDateTime(time.value)
                          .format(pattern: "yyyy-MM-dd")
                    },
                  )),
                ).padding(right: 8),
                FilledButton(
                  onPressed: () {
                    text.clear();
                    chooseBuilding();
                  },
                  child: Text(FlutterI18n.translate(
                    context,
                    "empty_classroom.building",
                    translationParams: {"building": chosen.value.name},
                  )),
                ),
              ].toRow(),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.center)
                .padding(bottom: 8),
            [
              [
                getIcon(true),
                const SizedBox(width: 4.0),
                Text(FlutterI18n.translate(
                  context,
                  "empty_classroom.occupied",
                )),
              ].toRow().padding(right: 8.0),
              [
                getIcon(false),
                const SizedBox(width: 4.0),
                Text(FlutterI18n.translate(
                  context,
                  "empty_classroom.empty",
                )),
              ].toRow(),
            ].toRow(mainAxisAlignment: MainAxisAlignment.center),
          ]
              .toColumn()
              .padding(horizontal: 14, top: 8, bottom: 6)
              .constrained(maxWidth: 480),
          if (state.value == SessionState.fetching)
            const CircularProgressIndicator().center().expanded()
          else if (state.value == SessionState.error)
            ElevatedButton(
              onPressed: updateData,
              child: Text(
                FlutterI18n.translate(context, "general.retry"),
              ),
            ).expanded()
          else
            DataTable2(
              dividerThickness: 0,
              columnSpacing: 0,
              horizontalMargin: 6,
              headingRowHeight: 0,
              columns: [
                DataColumn2(
                  label: Text(FlutterI18n.translate(
                    context,
                    "empty_classroom.classroom",
                  )).center(),
                  fixedWidth: 100,
                ),
                DataColumn2(
                  label: const Text('1-4').center(),
                  fixedWidth: 100,
                ),
                DataColumn2(
                  label: const Text('5-8').center(),
                  fixedWidth: 100,
                ),
                DataColumn2(
                  label: const Text('9-10').center(),
                  fixedWidth: 50,
                ),
              ],
              rows: List<DataRow>.generate(
                data.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(
                      data[index].name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ).center()),
                    DataCell(Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4.0,
                      children: List.generate(
                        4,
                        (i) => getIcon(data[index].isUsed[i], index: i + 1),
                      ),
                    ).center()),
                    DataCell(Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4.0,
                      children: List.generate(
                        4,
                        (i) => getIcon(data[index].isUsed[i + 4], index: i + 5),
                      ),
                    ).center()),
                    DataCell(Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4.0,
                      children: List.generate(
                        2,
                        (i) => getIcon(data[index].isUsed[i + 8], index: i + 9),
                      ),
                    ).center()),
                  ],
                ),
              ),
            ).constrained(maxWidth: 480).center().safeArea().expanded(),
        ],
      );
    });
  }
}
