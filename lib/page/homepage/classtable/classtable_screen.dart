// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';
import 'package:yidianshi/page/homepage/classtable/widgets/class_table_popup_menu.dart';
import 'package:yidianshi/page/homepage/classtable/widgets/class_table_view_widget.dart';
import 'package:yidianshi/page/homepage/classtable/widgets/week_selector.dart';
import 'package:yidianshi/widget/classtable/empty_classtable_page.dart';
import 'package:yidianshi/widget/classtable/classtable_constant.dart';
import 'package:yidianshi/widget/widget.dart';

class ClassTableScreen extends GetView<ClassTableController> {
  const ClassTableScreen({super.key});

  Future<void> importPartnerData(BuildContext context) async {
    if (controller.havePartner) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(FlutterI18n.translate(
            context,
            "confirm_title",
          )),
          content: Text(FlutterI18n.translate(
            context,
            "classtable.partner_classtable.override_dialog",
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(FlutterI18n.translate(context, "cancel")),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(FlutterI18n.translate(context, "confirm")),
            )
          ],
        ),
      );
      if (!context.mounted || confirm != true) {
        return;
      }
    }

    if (!context.mounted) return;
    
    final result = await controller.importPartnerClassFile();
    if (!context.mounted) return;

    switch (result) {
      case null:
      case 'decode_failed':
        showToast(
          context: context,
          msg: FlutterI18n.translate(
            context,
            "classtable.partner_classtable.no_file",
          ),
        );
        break;
      case 'no_permission':
        showToast(
          context: context,
          msg: FlutterI18n.translate(
            context,
            "classtable.partner_classtable.no_permission",
          ),
        );
        break;
      case 'error':
        showToast(
          context: context,
          msg: FlutterI18n.translate(
            context,
            "classtable.partner_classtable.problem",
          ),
        );
        break;
      case 'success':
        showToast(
          context: context,
          msg: FlutterI18n.translate(
            context,
            "classtable.partner_classtable.success",
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Obx(() {
      if (controller.classDetail.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterI18n.translate(
              context,
              "classtable.partner_classtable.page_title",
            )),
            leading: IconButton(
              icon: Icon(
                Platform.isIOS || Platform.isMacOS
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          body: const EmptyClasstablePage(),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
                controller.isPartner
                    ? FlutterI18n.translate(
                        context,
                        "classtable.partner_page_title",
                        translationParams: {
                          "partner_name": controller.partnerName ?? "Sweetie"
                        },
                      )
                    : FlutterI18n.translate(
                        context,
                        "classtable.page_title",
                      ),
              )),
          leading: IconButton(
            icon: Icon(
              Platform.isIOS || Platform.isMacOS
                  ? Icons.arrow_back_ios
                  : Icons.arrow_back,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            if (controller.havePartner) const ClassTablePopupMenu(),
            if (controller.haveClass) const ClassTablePopupMenu(),
          ],
        ),
        body: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(
                MediaQuery.sizeOf(context).height >= 500
                    ? topRowHeightBig
                    : topRowHeightSmall,
              ),
              child: const WeekSelector(),
            ),
            DecoratedBox(
              decoration: decoration,
              child: const ClassTableViewWidget(),
            ).expanded(),
          ],
        ),
      );
    });
  }
}
