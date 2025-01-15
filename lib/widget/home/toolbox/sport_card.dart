// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:talker_flutter/talker_flutter.dart';
import 'package:yidianshi/widget/public_widget_all/context_extension.dart';
import 'package:yidianshi/page/setting/dialogs/sport_password_dialog.dart';
import 'package:yidianshi/page/homepage/sport/sport_window.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/widget/home/small_function_card.dart';
import 'package:get/get.dart';
import 'package:yidianshi/routes/routes.dart';

class SportCard extends StatelessWidget {
  const SportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallFunctionCard(
      onTap: () async {
        bool isGood = true;
        if (preference.getString(preference.Preference.sportPassword).isEmpty) {
          isGood = await showDialog<bool>(
                context: context,
                builder: (context) => const SportPasswordDialog(),
              ) ??
              false; // 当返回值为 null 时，设置 isGood 为 false
        }
        if (context.mounted && isGood) {
          Get.toNamed(
            Routes.HOME + Routes.SPORT,
            preventDuplicates: true,
            id: null,
          );
          //context.pushReplacement(const SportWindow());
        }
      },
      icon: MingCuteIcons.mgc_run_fill,
      nameKey: "homepage.toolbox.sport",
    );
  }
}
