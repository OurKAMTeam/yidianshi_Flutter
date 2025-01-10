import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:yidianshi/shared/common/app_init.dart';
import 'package:yidianshi/shared/common/app_theme.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/widget/home/info_widget/controller/theme_controller.dart';
import 'package:yidianshi/routes/routes.dart';
import 'package:yidianshi/xd_api/base/ids_session.dart';
import 'package:yidianshi/shared/utils/logger.dart';
import 'package:home_widget/home_widget.dart';
import 'di.dart' ;
import 'app_binding.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await DenpendencyInjection.init();
  await AppInit.init();
  Catcher2(
    rootWidget: const MyApp(),
    debugConfig: preference.catcherOptions,
    releaseConfig: preference.catcherOptions,
    navigatorKey: preference.debuggerKey,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeController appTheme = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) HomeWidget.setAppGroupId(preference.appId);
    //HomeWidget.registerInteractivityCallback(backgroundCallback);

    IDSSession().dio.get("https://www.xidian.edu.cn");
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (c) => GetMaterialApp(
        initialBinding: AppBinding(),
        initialRoute: Routes.LOGIN,
        getPages: AppPages.routes,
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              fallbackFile: "zh_CN",
              useCountryCode: true,
              forcedLocale: c.locale,
            ),
            missingTranslationHandler: (key, locale) {
                log.info(
                "--- Missing Key: $key, "
                "languageCode: ${locale?.languageCode ?? "unknown"}",
              );
              //print("--- Missing Key: $key, languageCode: ${locale?.languageCode ?? "unknown"}");
            },
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
        ],
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        navigatorKey: preference.debuggerKey,
        title: Platform.isIOS || Platform.isMacOS ? "XDYou" : 'Traintime PDA',
        theme: AppTheme.getLightTheme(c),
        darkTheme: AppTheme.getDarkTheme(c),
        themeMode: c.colorState,
        // home: DefaultTextStyle.merge(
        //   style: const TextStyle(textBaseline: TextBaseline.ideographic),
        //   child: const LoginWindow(),
        // ),
        builder: (context, widget) {
          Catcher2.addDefaultErrorWidget(
            showStacktrace: true,
            title: "未预期情况发生！",
            description: "An unexpected behaviour occured!",
            maxWidthForSmallMode: 150,
          );
          if (widget != null) return widget;
          throw StateError('widget is null');
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
