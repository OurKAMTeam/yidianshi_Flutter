import 'package:get/get.dart';
import 'package:yidianshi/page/home/home_binding.dart';
import 'package:yidianshi/page/home/home_screen.dart';
import 'package:yidianshi/page/login/login_binding.dart';
import 'package:yidianshi/page/login/login_window.dart';
// import 'package:yidianshi/shared/utils/preference.dart' as preference;
// import 'package:yidianshi/xd_api/base/ids_session.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
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