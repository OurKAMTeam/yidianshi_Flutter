import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/widget/widget.dart';

class AddClassController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final teacherController = TextEditingController();
  final locationController = TextEditingController();
  
  final selectedWeekday = 1.obs;
  final startTime = 1.obs;
  final endTime = 1.obs;
  
  final RxList<bool> selectedWeeks;
  final int semesterLength;
  final (ClassDetail, TimeArrangement)? toChange;

  AddClassController({
    required this.semesterLength,
    this.toChange,
  }) : selectedWeeks = List<bool>.generate(
          semesterLength,
          (index) => false,
        ).obs {
    if (toChange != null) {
      nameController.text = toChange!.$1.name;
      teacherController.text = toChange!.$2.teacher ?? '';
      locationController.text = toChange!.$2.classroom ?? '';
      selectedWeeks.value = toChange!.$2.weekList;
      selectedWeekday.value = toChange!.$2.day;
      startTime.value = toChange!.$2.start;
      endTime.value = toChange!.$2.stop;
    }
  }

  void toggleWeek(int index) {
    selectedWeeks[index] = !selectedWeeks[index];
    //update();  // 需要这行来通知 GetX 更新 UI
  }

  void updateWeekday(int value) {
    selectedWeekday.value = value;
    //update();  // 需要这行来通知 GetX 更新 UI
  }

  void updateStartTime(int value) {
    startTime.value = value;
    //update();  // 需要这行来通知 GetX 更新 UI
  }

  void updateEndTime(int value) {
    endTime.value = value;
    //update();  // 需要这行来通知 GetX 更新 UI
  }

  bool validateForm(BuildContext context) {
    if (nameController.text.isEmpty) {
      showToast(
        context: context,
        msg: FlutterI18n.translate(
          context,
          "classtable.class_add.class_name_empty_message",
        ),
      );
      return false;
    }
    
    if (!(selectedWeekday.value > 0 && selectedWeekday.value <= 7) || 
        !(startTime.value <= endTime.value)) {
      showToast(
        context: context,
        msg: FlutterI18n.translate(
          context,
          "classtable.class_add.wrong_time_message",
        ),
      );
      return false;
    }
    
    return true;
  }

  (ClassDetail, TimeArrangement) getClassData() {
    final classDetail = ClassDetail(name: nameController.text);
    final timeArrangement = TimeArrangement(
      source: Source.user,
      index: toChange?.$2.index ?? -1,
      teacher: teacherController.text.isNotEmpty ? teacherController.text : null,
      classroom: locationController.text.isNotEmpty ? locationController.text : null,
      weekList: selectedWeeks.toList(),
      day: selectedWeekday.value,
      start: startTime.value,
      stop: endTime.value,
    );
    return (classDetail, timeArrangement);
  }

  List<(int, String)> get weekdays => [
    (1, '星期一'),
    (2, '星期二'),
    (3, '星期三'),
    (4, '星期四'),
    (5, '星期五'),
    (6, '星期六'),
    (7, '星期日'),
  ];

  @override
  void onClose() {
    nameController.dispose();
    teacherController.dispose();
    locationController.dispose();
    super.onClose();
  }
}

class ClassDetail {
  final String name;
  final String? teacher;
  final String? classroom;

  ClassDetail({
    required this.name,
    this.teacher,
    this.classroom,
  });
}

class TimeArrangement {
  final Source source;
  final int index;
  final String? teacher;
  final String? classroom;
  final List<bool> weekList;
  final int day;
  final int start;
  final int stop;

  TimeArrangement({
    required this.source,
    required this.index,
    this.teacher,
    this.classroom,
    required this.weekList,
    required this.day,
    required this.start,
    required this.stop,
  });
}

enum Source {
  user,
  // Add other sources as needed
}
