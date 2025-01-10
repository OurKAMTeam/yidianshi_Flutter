import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yidianshi/shared/utils/logger.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/xd_api/base/network_session.dart' as repo_general;


class AppInit {
  static Future<void> init() async {
    // Make sure the library is initialized.

    log.info(
      "Traintime PDA Codebase is written by BenderBlog Rodriguez and contributors",
    );

    // Disable horizontal screen in phone.
    // See https://stackoverflow.com/questions/57755174/getting-screen-size-in-a-class-without-buildcontext-in-flutter
    final data = WidgetsBinding.instance.platformDispatcher.views.first;

    log.info(
      "Shortest size: ${data.physicalSize.width} ${data.physicalSize.height} "
      "${min(data.physicalSize.width, data.physicalSize.height) / data.devicePixelRatio}",
    );

    if (min(data.physicalSize.width, data.physicalSize.height) /
            data.devicePixelRatio <
        480) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    // Loading cookiejar.
    repo_general.supportPath = await getApplicationSupportDirectory();
    preference.prefs = await SharedPreferences.getInstance();
    preference.packageInfo = await PackageInfo.fromPlatform();
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
