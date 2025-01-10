// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:yidianshi/widget/home/info_widget/controller/experiment_controller.dart';
import 'package:yidianshi/page/public_widget/context_extension.dart';
import 'package:yidianshi/page/setting/dialogs/experiment_password_dialog.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/page/experiment/experiment_window.dart';
import 'package:yidianshi/widget/home/small_function_card.dart';

class ExperimentCard extends StatelessWidget {
  const ExperimentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallFunctionCard(
      onTap: () async {
        bool isGood = true;
        if (preference
            .getString(preference.Preference.experimentPassword)
            .isEmpty) {
          isGood = await showDialog(
                context: context,
                builder: (context) => const ExperimentPasswordDialog(),
              ) ??
              false;
        }
        if (context.mounted && isGood == true) {
          Get.put(ExperimentController()).get();
          context.pushReplacement(const ExperimentWindow());
        }
      },
      icon: MingCuteIcons.mgc_science_line,
      nameKey: "homepage.toolbox.experiment",
    );
  }
}
