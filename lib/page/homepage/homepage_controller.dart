import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yidianshi/shared/utils/preference.dart' as prefs;
import 'package:yidianshi/widget/home/info_widget/electricity_card.dart';
import 'package:yidianshi/widget/home/info_widget/library_card.dart';
import 'package:yidianshi/widget/home/info_widget/school_card_info_card.dart';
import 'package:yidianshi/widget/home/toolbox/schoolnet_card.dart';
import 'package:yidianshi/widget/home/toolbox/empty_classroom_card.dart';
import 'package:yidianshi/widget/home/toolbox/exam_card.dart';
import 'package:yidianshi/widget/home/toolbox/experiment_card.dart';
import 'package:yidianshi/widget/home/toolbox/score_card.dart';
import 'package:yidianshi/widget/home/toolbox/sport_card.dart';
//import 'package:yidianshi/widget/home/toolbox/toolbox_card.dart';


class HomePageController extends GetxController {
  static HomePageController get to => Get.find();

  final List<Widget> children = const [
    ElectricityCard(),
    LibraryCard(), // complete
    SchoolCardInfoCard(),
  ];

  final List<Widget> smallFunction = [
    const ScoreCard(),  // complete
    const ExamCard(),  // complete
    const EmptyClassroomCard(), // complete
    const SchoolnetCard(),
    if (prefs.getBool(prefs.Preference.role) == false) ...[
      const ExperimentCard(), // complete
      const SportCard(), // complete
    ],
    //const ToolboxCard(),
  ];

  String get timeString {
    DateTime now = DateTime.now();

    if (now.hour >= 5 && now.hour < 9) {
      return "homepage.time_string.morning";
    }
    if (now.hour >= 9 && now.hour < 11) {
      return "homepage.time_string.before_noon";
    }
    if (now.hour >= 11 && now.hour < 14) {
      return "homepage.time_string.at_noon";
    }
    if (now.hour >= 14 && now.hour < 18) {
      return "homepage.time_string.afternoon";
    }
    if (now.hour >= 18 || now.hour == 0) {
      return "homepage.time_string.night";
    }
    return "homepage.time_string.midnight";
  }

  TextStyle getTextStyle(BuildContext context) => TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      );

  void updateWithCaptcha({
    required BuildContext context,
    required Future<bool> Function(String) sliderCaptcha,
  }) {
    // Implementation of update function
  }
}
