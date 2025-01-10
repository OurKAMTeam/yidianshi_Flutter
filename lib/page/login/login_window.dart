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
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(
          iconData,
          size: _inputFieldIconSize,
          color: _inputFieldColor,
        ),
        hintStyle: TextStyle(
          fontSize: _inputFieldFontSize,
          color: _inputFieldColor,
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
        fillColor: _inputFieldBackgroundColor,
      );

  Widget _contentColumn(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller.idsAccountController,
            decoration: _inputDecoration(
              iconData: MingCuteIcons.mgc_user_3_fill,
              hintText: FlutterI18n.translate(context, "login.identity_number"),
            ),
            style: TextStyle(
              fontSize: _inputFieldFontSize,
              color: _inputFieldColor,
            ),
          ).center().padding(horizontal: 12).decorated(
            color: _inputFieldBackgroundColor,
            borderRadius: BorderRadius.circular(roundRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(19),
                offset: const Offset(0, 2),
                blurRadius: 1,
              ),
            ],
          ).height(64),
          const SizedBox(height: 16.0),
          Obx(() => TextField(
            controller: controller.idsPasswordController,
            obscureText: !controller.isPasswordVisible.value,
            style: TextStyle(
              fontSize: _inputFieldFontSize,
              color: _inputFieldColor,
            ),
            decoration: _inputDecoration(
              iconData: MingCuteIcons.mgc_safe_lock_fill,
              hintText: FlutterI18n.translate(context, "login.password"),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: _inputFieldIconSize,
                  color: _inputFieldColor,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ).center().padding(horizontal: 12).decorated(
            color: _inputFieldBackgroundColor,
            borderRadius: BorderRadius.circular(roundRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(19),
                offset: const Offset(0, 2),
                blurRadius: 1,
              ),
            ],
          ).height(64)),
          SizedBox(height: Get.width / Get.height > 1.0 ? 16.0 : 64.0),
          Obx(() => FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(12.0),
              minimumSize: const Size(double.infinity, 56),
              maximumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundRadius),
              ),
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
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: Get.width / Get.height > 1.0 ? Get.width * 0.2 : widthOfSquare,
          right: Get.width / Get.height > 1.0 ? Get.width * 0.2 : widthOfSquare,
          top: kToolbarHeight,
        ),
        child: Get.width / Get.height > 1.0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppIconWidget(size: 64).gestures(
                    onTap: () => Get.toNamed('/about'),
                  ),
                  const SizedBox(width: 48),
                  Expanded(child: _contentColumn(context)),
                ],
              )
            : Column(
                children: [
                  const AppIconWidget(size: 64)
                      .padding(vertical: kToolbarHeight * 0.75)
                      .gestures(onTap: () => Get.toNamed('/about')),
                  _contentColumn(context),
                ],
              ).center(),
      ),
    );
  }
}
