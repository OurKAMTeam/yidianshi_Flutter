// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

// Login window of the program.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/widget/widget.dart';
import './login_controller.dart';

class LoginWindow extends GetView<LoginController> {
  const LoginWindow({super.key});

  /// Variables of the input textfield
  static const Color _inputFieldBackgroundColor = Color.fromRGBO(250, 250, 250, 1);
  static const Color _inputFieldColor = Color.fromRGBO(35, 62, 99, 0.35);
  static const double _inputFieldIconSize = 28;
  static const double _inputFieldFontSize = 20;
  static const double widthOfSquare = 32.0;
  static const double roundRadius = 36;

  InputDecoration _inputDecoration({
    required IconData iconData,
    required String hintText,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        prefixIcon: Icon(iconData),
        hintText: hintText,
        suffixIcon: suffixIcon,
      );

  Widget _contentColumn(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller.idsAccountController,
            decoration: _inputDecoration(
              iconData: MingCuteIcons.mgc_user_3_fill,
              hintText: FlutterI18n.translate(context, "login.identity_number"),
            ),
          ).center(),
          const SizedBox(height: 16.0),
          Obx(() => TextField(
            controller: controller.idsPasswordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: _inputDecoration(
              iconData: MingCuteIcons.mgc_safe_lock_fill,
              hintText: FlutterI18n.translate(context, "login.password"),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ).center()),
          SizedBox(height: Get.width / Get.height > 1.0 ? 16.0 : 32.0),
          Obx(() => FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              maximumSize: const Size(double.infinity, 64),
            ),
            onPressed: controller.isLoading.value ? null : controller.login,
            child: Text(
              FlutterI18n.translate(context, "login.login"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          )),
          const SizedBox(height: 8.0),
          const ButtomButtons(),
        ],
      ).constrained(maxWidth: 400);

  @override
  Widget build(BuildContext context) {
    final isLandscape = Get.width / Get.height > 1.0;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background and Logo
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLandscape ? Get.width * 0.2 : widthOfSquare,
              ),
              child: isLandscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppIconWidget(size: 64).gestures(
                        onTap: () => Get.toNamed('/about'),
                      ),
                      const SizedBox(width: 48),
                      const Spacer(),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: kToolbarHeight),
                      const AppIconWidget(size: 64).gestures(
                        onTap: () => Get.toNamed('/about'),
                      ),
                    ],
                  ),
            ),
          ),
          
          // Login Form
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: isLandscape ? Get.width * 0.2 : widthOfSquare,
                right: isLandscape ? Get.width * 0.2 : widthOfSquare,
                top: isLandscape ? kToolbarHeight : kToolbarHeight + 128,
              ),
              child: isLandscape
                ? Row(
                    children: [
                      const Spacer(flex: 2),
                      Expanded(
                        flex: 3,
                        child: _contentColumn(context),
                      ),
                    ],
                  )
                : _contentColumn(context),
            ),
          ),
        ],
      ),
    );
  }
}
