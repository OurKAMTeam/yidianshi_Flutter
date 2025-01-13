// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/xd_api/tool/message_session.dart' as message;
import 'home_controller.dart';

class PageInformation {
  final int index;
  final String name;
  final IconData icon;
  final IconData iconChoice;
  final MainTabs tab;

  PageInformation({
    required this.index,
    required this.name,
    required this.icon,
    required this.iconChoice,
    required this.tab,
  });
}

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final List<PageInformation> pageInformation = [
    PageInformation(
      index: 0,
      name: "主页",
      icon: MingCuteIcons.mgc_home_1_line,
      iconChoice: MingCuteIcons.mgc_home_1_fill,
      tab: MainTabs.home,
    ),
    PageInformation(
      index: 1,
      name: "评论",
      icon: MingCuteIcons.mgc_message_2_line,
      iconChoice: MingCuteIcons.mgc_message_2_fill,
      tab: MainTabs.post,
    ),
    PageInformation(
      index: 2,
      name: "功能",
      icon: MingCuteIcons.mgc_tool_line,
      iconChoice: MingCuteIcons.mgc_tool_fill,
      tab: MainTabs.functions,
    ),
    PageInformation(
      index: 3,
      name: "设置",
      icon: MingCuteIcons.mgc_settings_2_line,
      iconChoice: MingCuteIcons.mgc_settings_2_fill,
      tab: MainTabs.setting,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(() => Scaffold(
        extendBodyBehindAppBar: true,
        body: Navigator(
          key: Get.nestedKey(1), // 使用嵌套导航
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => _buildContent(controller.currentTab.value),
              settings: settings,
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: pageInformation.map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e.icon),
              activeIcon: Icon(e.iconChoice),
              label: e.name,
            ),
          ).toList(),
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.getCurrentIndex(controller.currentTab.value),
          onTap: (index) => controller.switchTab(index),
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    );
  }


    Widget _buildContent(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return controller.homeTab;
      case MainTabs.post:
        return controller.postTab;
      case MainTabs.functions:
        return controller.functionsTab;
      case MainTabs.setting:
        return controller.settingTab;
      default:
        return controller.homeTab;
    }
  }

  void _showUpdateNotice(BuildContext context) {
    if (message.updateMessage.value != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("发现新版本"),
          content: Obx(() => Text(message.updateMessage.value!.update.join('\n'))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("确定"),
            ),
          ],
        ),
      );
    }
  }

  void _showOfflineModeNotice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(FlutterI18n.translate(
          context,
          "homepage.offline_mode_title",
        )),
        content: Text(FlutterI18n.translate(
          context,
          "homepage.offline_mode_content",
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(FlutterI18n.translate(context, "confirm")),
          ),
        ],
      ),
    );
  }

  Future<void> _showPasswordWrongDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(FlutterI18n.translate(
          context,
          "homepage.password_wrong_title",
        )),
        content: Text(FlutterI18n.translate(
          context,
          "homepage.password_wrong_content",
        )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.restartApp();
            },
            child: Text(FlutterI18n.translate(context, "confirm")),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showOfflineModeNotice(context);
            },
            child: Text(FlutterI18n.translate(
              context,
              "homepage.password_wrong_denial",
            )),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmFileOverwrite(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(FlutterI18n.translate(context, "confirm_title")),
        content: Text(FlutterI18n.translate(
          context,
          "homepage.input_partner_data.confirm_content",
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(FlutterI18n.translate(context, "cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(FlutterI18n.translate(context, "confirm")),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
