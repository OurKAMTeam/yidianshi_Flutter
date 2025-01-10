// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/page/homepage/homepage.dart';
import 'package:yidianshi/page/xdu_planet/xdu_planet_page.dart';
import 'package:yidianshi/page/setting/setting.dart';
import 'package:yidianshi/widget/widget.dart';
import 'home_controller.dart';

class PageInformation {
  final int index;
  final String name;
  final IconData icon;
  final IconData iconChoice;

  PageInformation({
    required this.index,
    required this.name,
    required this.icon,
    required this.iconChoice,
  });
}

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final List<Widget> pages = [
    const MainPage(),
    const XDUPlanetPage(),
    const SettingWindow(),
  ];

  final List<PageInformation> pageInformation = [
    PageInformation(
      index: 0,
      name: "主页",
      icon: MingCuteIcons.mgc_home_1_line,
      iconChoice: MingCuteIcons.mgc_home_1_fill,
    ),
    PageInformation(
      index: 1,
      name: "西电星球",
      icon: MingCuteIcons.mgc_planet_line,
      iconChoice: MingCuteIcons.mgc_planet_fill,
    ),
    PageInformation(
      index: 2,
      name: "设置",
      icon: MingCuteIcons.mgc_settings_2_line,
      iconChoice: MingCuteIcons.mgc_settings_2_fill,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        controller: controller.pageController,
        children: pages,
        onPageChanged: (index) => controller.selectedIndex = index,
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 64,
          selectedIndex: controller.selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (index) {
            controller.selectedIndex = index;
            controller.pageController.jumpToPage(index);
          },
          destinations: pageInformation.map((info) {
            return NavigationDestination(
              icon: controller.selectedIndex == info.index
                  ? Icon(info.iconChoice)
                  : Icon(info.icon),
              label: info.name,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showUpdateNotice(BuildContext context) {
    if (controller.hasUpdate) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("发现新版本"),
          content: Obx(() => Text(controller.updateMessage)),
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
