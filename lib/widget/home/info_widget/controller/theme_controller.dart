// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/shared/utils/logger.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/shared/common/themes/color_seed.dart';
//import 'package:yidianshi/themes/color_seed.dart';
//import 'package:yidianshi/themes/demo_blue.dart';

class ThemeController extends GetxController {
  late ThemeMode colorState;
  late Locale locale;
  late List<FlexSchemeColor> color;

  @override
  void onInit() {
    super.onInit();
    onUpdate();
  }

  void onUpdate() {
    log.info("[ThemeController] Changing color...");
    int index = preference.getInt(preference.Preference.color);
    color = pdaColorScheme.sublist(index * 2, index * 2 + 1);

    log.info("[ThemeController] Changing brightness...");
    colorState =
        demoBlueModeMap[preference.getInt(preference.Preference.brightness)]!;
    log.info("[ThemeController] Changing locale...");
    String localization = preference.getString(
      preference.Preference.localization,
    );
    locale = Locale.fromSubtags(
      languageCode: localization.isNotEmpty ? localization : "und",
    );

    update();
  }
}
