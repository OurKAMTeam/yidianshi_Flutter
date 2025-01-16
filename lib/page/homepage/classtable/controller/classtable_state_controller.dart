import 'export_classtable_controller.dart';
import 'arrangement_classtable_controller.dart';
import 'partner_classtable_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// Main controller that combines all class table functionality
class ClassTableStateController extends PartnerClassTableController
    with ExportClassTableController, ArrangementClassTableController {
  BoxConstraints constraints = const BoxConstraints();
  
  ClassTableStateController({
    required super.currentWeek,
  });

  static ClassTableStateController? of(BuildContext context) {
    return Get.find<ClassTableStateController>();
  }

  static ClassTableStateController get to => Get.find<ClassTableStateController>();

  /// Get the list of dates for the current chosen week
  List<DateTime> get dateList {
    final weekStart = startDay.add(Duration(days: 7 * (chosenWeek - 1)));
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }
}