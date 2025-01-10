// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:content_resolver/content_resolver.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:restart_app/restart_app.dart';

import 'package:yidianshi/shared/utils/logger.dart';
import 'package:yidianshi/xd_api/tool/message_session.dart' as message;
import 'package:yidianshi/xd_api/base/ids_session.dart';
import 'package:yidianshi/xd_api/base/network_session.dart';
import 'package:yidianshi/widget/home/info_widget/controller/classtable_controller.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/xd_api/tool/classtable_session.dart';
import 'package:yidianshi/widget/widget.dart';
import 'package:restart_app/restart_app.dart';


class HomeController extends GetxController with WidgetsBindingObserver {
  final _selectedIndex = 0.obs;
  late PageController pageController;
  late StreamSubscription _intentSub;
  static bool refreshAtStart = false;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;

  bool get hasUpdate => message.updateMessage.value != null;
  String get updateMessage => message.updateMessage.value?.toString() ?? '';

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: _selectedIndex.value);
    WidgetsBinding.instance.addObserver(this);

    if (Platform.isAndroid || Platform.isIOS) {
      _setupMediaSharing();
    }
  }

  void _setupMediaSharing() {
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      _handleSharedData,
      onError: (error, stacktrace) {
        log.error("getIntentDataStream error.", error, stacktrace);
      },
    );

    ReceiveSharingIntent.instance.getInitialMedia().then(_handleSharedData).catchError(
      (err, stacktrace) {
        log.error("getIntentDataStream error.", err, stacktrace);
      },
    );
  }

  @override
  void onClose() {
    if (Platform.isAndroid || Platform.isIOS) {
      _intentSub.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateCurrentData();
    }
  }

  Future<void> _handleSharedData(List<SharedMediaFile> value) async {
    if (value.isEmpty) return;
    
    log.info("Input data: ${value.first.path}");

    if (Uri.tryParse(value.first.path) == null) {
      showToast(
        context: Get.context!,
        msg: FlutterI18n.translate(
          Get.context!,
          "homepage.input_partner_data.route_not_exist",
        ),
      );
      ReceiveSharingIntent.instance.reset();
      return;
    }

    log.info("Partner File Position: ${value.first.path}");
    await _processPartnerFile(value.first);
  }

  Future<void> _processPartnerFile(SharedMediaFile file) async {
    final c = Get.find<ClassTableController>();
    if (c.state != ClassTableState.fetched) {
      showToast(
        context: Get.context!,
        msg: FlutterI18n.translate(
          Get.context!,
          "homepage.input_partner_data.not_loaded",
        ),
      );
      return;
    }

    final partnerFile = File("${supportPath.path}/${ClassTableFile.partnerClassName}");
    if (partnerFile.existsSync() && !await _confirmFileOverwrite()) {
      return;
    }

    String source = await _readFileContent(file);
    if (source.isEmpty) return;

    await _validateAndSavePartnerData(source);
  }

  Future<bool> _confirmFileOverwrite() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(FlutterI18n.translate(Get.context!, "confirm_title")),
        content: Text(FlutterI18n.translate(
          Get.context!,
          "homepage.input_partner_data.confirm_content",
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(FlutterI18n.translate(Get.context!, "cancel")),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(FlutterI18n.translate(Get.context!, "confirm")),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<String> _readFileContent(SharedMediaFile file) async {
    try {
      String source = "";
      if (Platform.isAndroid) {
        Content content = await ContentResolver.resolveContent(file.path);
        source = utf8.decode(content.data.toList());
      } else {
        source = File.fromUri(Uri.parse(file.path)).readAsStringSync();
      }
      return source;
    } catch (e) {
      showToast(
        context: Get.context!,
        msg: FlutterI18n.translate(
          Get.context!,
          "homepage.input_partner_data.failed_get_file",
        ),
      );
      log.error("Import partner classtable error.", e);
      throw Exception("Failed to read file content");
    }
  }

  Future<void> _validateAndSavePartnerData(String source) async {
    try {
      // final supportPath = await getApplicationSupportDirectory();
      final current = await File("${supportPath.path}/${ClassTableFile.partnerClassName}")
          .readAsString();

      if (!_validateSemesterCode(current, source)) return;

      File("${supportPath.path}/${ClassTableFile.partnerClassName}")
        .writeAsStringSync(source);
      
      showToast(
        context: Get.context!,
        msg: FlutterI18n.translate(
          Get.context!,
          "homepage.input_partner_data.success_message",
        ),
      );
    } catch (error, stacktrace) {
      log.error("Error occurred while importing partner class.", error, stacktrace);
      showToast(
        context: Get.context!,
        msg: FlutterI18n.translate(
          Get.context!,
          "homepage.input_partner_data.failed_import",
        ),
      );
    } finally {
      ReceiveSharingIntent.instance.reset();
    }
  }

  bool _validateSemesterCode(String current, String input) {
    var yearNotEqual = current.substring(0, 4) != input.substring(0, 4);
    var lastNotEqual = current.substring(current.length - 1) != 
                       input.substring(input.length - 1);
    
    if (yearNotEqual || lastNotEqual) {
      throw NotSameSemesterException(
        msg: "Not the same semester. This semester: $current. "
            "Input source: $input. "
            "This partner classtable is going to be deleted.",
      );
    }
    return true;
  }

  Future<void> loginAsync() async {
    updateCurrentData(); // load cache data
    showToast(
      context: Get.context!,
      msg: FlutterI18n.translate(
        Get.context!,
        "homepage.login_message",
      ),
    );

    try {
      await update(
        context: Get.context!,
        forceRetryLogin: true,
        sliderCaptcha: (String cookieStr) {
          return SliderCaptchaClientProvider(cookie: cookieStr).solve(Get.context!);
        },
      );
    } finally {
      _handleLoginResult();
    }
  }

  void _handleLoginResult() async {
    if (loginState == IDSLoginState.success) {
      showToast(
        context: Get.context!,
        msg: FlutterI18n.translate(
          Get.context!,
          "homepage.successful_login_message",
        ),
      );
    } else if (loginState == IDSLoginState.passwordWrong) {
      await preference.remove(preference.Preference.idsPassword);
      await _showPasswordWrongDialog();
    } else {
      _showOfflineModeNotice();
    }
  }

  Future<void> _showPasswordWrongDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text(FlutterI18n.translate(
          Get.context!,
          "homepage.password_wrong_title",
        )),
        content: Text(FlutterI18n.translate(
          Get.context!,
          "homepage.password_wrong_content",
        )),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
    Restart.restartApp();
            },
            child: Text(FlutterI18n.translate(Get.context!, "confirm")),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _showOfflineModeNotice();
            },
            child: Text(FlutterI18n.translate(
              Get.context!,
              "homepage.password_wrong_denial",
            )),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showOfflineModeNotice() {
    Get.dialog(
      AlertDialog(
        title: Text(FlutterI18n.translate(
          Get.context!,
          "homepage.offline_mode_title",
        )),
        content: Text(FlutterI18n.translate(
          Get.context!,
          "homepage.offline_mode_content",
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(FlutterI18n.translate(Get.context!, "confirm")),
          ),
        ],
      ),
    );
  }

  void _showUpdateNotice() {
    if (message.updateMessage.value != null) {
      Get.dialog(
        AlertDialog(
          title: const Text("发现新版本"),
          content: Obx(() => Text(message.updateMessage.value!.update.join('\n'))),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("确定"),
            ),
          ],
        ),
      );
    }
  }

  void updateCurrentData() {
    updateCurrentData();
  }

  void restartApp() {
    Restart.restartApp();
  }

  @override
  void onReady() {
    super.onReady();
    if (!refreshAtStart) {
      _initializeApp();
    }
  }

  void _initializeApp() async {
    message.checkMessage();
    final hasUpdate = await message.checkUpdate();
    if (hasUpdate ?? false) {
      _showUpdateNotice();
    }

    log.info(
      "[home][BackgroundFetchFromHome]"
      "Current loginstate: $loginState, if none will loginAsync.",
    );

    if (loginState == IDSLoginState.none) {
      loginAsync();
    } else {
      update(
        context: Get.context!,
        forceRetryLogin: true,
        sliderCaptcha: (String cookieStr) {
          return SliderCaptchaClientProvider(cookie: cookieStr).solve(Get.context!);
        },
      );
    }
    refreshAtStart = true;
  }
}
