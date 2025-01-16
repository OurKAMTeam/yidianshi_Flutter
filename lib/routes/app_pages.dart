import 'package:get/get.dart';
import 'package:yidianshi/page/home/home_binding.dart';
import 'package:yidianshi/page/home/home_screen.dart';
import 'package:yidianshi/page/login/login_binding.dart';
import 'package:yidianshi/page/login/login_window.dart';
import 'package:yidianshi/page/homepage/score/score_binding.dart';
import 'package:yidianshi/page/homepage/score/score_screen.dart';
import 'package:yidianshi/page/homepage/testpage/testpage_binding.dart';
import 'package:yidianshi/page/homepage/testpage/testpage_screen.dart';
import 'package:yidianshi/page/homepage/exam/exam_binding.dart';
import 'package:yidianshi/page/homepage/exam/exam_screen.dart';
import 'package:yidianshi/page/homepage/empty_classroom/empty_classroom_binding.dart';
import 'package:yidianshi/page/homepage/empty_classroom/empty_classroom_screen.dart';
import 'package:yidianshi/page/homepage/experiment/experiment_binding.dart';
import 'package:yidianshi/page/homepage/experiment/experiment_window.dart';
import 'package:yidianshi/page/homepage/sport/sport_binding.dart';
import 'package:yidianshi/page/homepage/sport/sport_window.dart';
import 'package:yidianshi/page/homepage/library/library_window.dart';
import 'package:yidianshi/page/homepage/library/library_binding.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_binding.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_screen.dart';
import 'package:yidianshi/page/homepage/classtable/add_page/add_class_screen.dart';
import 'package:yidianshi/page/homepage/classtable/add_page/add_class_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: Routes.SCORE,
          page: () => const ScoreScreen(),
          binding: ScoreBinding(),
        ),
        GetPage(
          name: Routes.EXAM,
          page: () => ExamScreen(time: DateTime.now()),
          binding: ExamBinding(),
        ),
        GetPage(
          name: Routes.EMPTY_CLASSROOM,
          page: () => const EmptyClassroomScreen(),
          binding: EmptyClassroomBinding(),
        ),
        GetPage(
          name: Routes.TESTPAGE,
          page: () => const TestPageScreen(),
          binding: TestPageBinding(),
        ),
        GetPage(
          name: Routes.EXPERIMENT,
          page: () => const ExperimentWindow(),
          binding: ExperimentBinding(),
        ),
        GetPage(
          name: Routes.SPORT,
          page: () => const SportWindow(),
          binding: SportBinding(),
        ),
        GetPage(
          name: Routes.LIBRARY,
          page: () => const LibraryWindow(),
          binding: LibraryBinding(),
        ),
        GetPage(
          name: Routes.CLASSTABLE,
          page: () => const ClassTableScreen(),
          binding: ClassTableBinding(),
          children: [
            GetPage(
              name: Routes.ADD_CLASS,
              page: () => const AddClassScreen(),
              binding: AddClassBinding(),
            ),
          ],
        ),
      ]),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginWindow(),
      binding: LoginBinding(),
    ),
  ];

  // static String determineInitialRoute() {
  //   if (preference.prefs?.getString(preference.Preference.idsPassword) != null &&
  //       preference.prefs?.getString(preference.Preference.idsAccount) != null) {
  //     IDSSession.username = preference.prefs!.getString(preference.Preference.idsAccount)!;
  //     IDSSession.password = preference.prefs!.getString(preference.Preference.idsPassword)!;
  //     return Routes.HOME;
  //   } else {
  //     return Routes.LOGIN;
  //   }
  // }
}