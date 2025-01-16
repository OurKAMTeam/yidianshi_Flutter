// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:yidianshi/shared/utils/localization.dart';

class LocalizationDialog extends StatelessWidget {
  const LocalizationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Localization> localizationList = Localization.values;

    return SimpleDialog(
      title: Text(FlutterI18n.translate(
        context,
        "setting.localization_dialog.title",
      )),
      children: List.generate(
        localizationList.length,
        (index) => SimpleDialogOption(
          onPressed: () => Get.back<Localization>(result: localizationList[index]),
          child: ListTile(
            title: Text(FlutterI18n.translate(
              context,
              localizationList[index].toShow,
            )),
          ),
        ),
      ),
    );
  }
}
