// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
//import 'package:yidianshi/page/homepage/classtable/add_page/class_add_window.dart';
import 'package:yidianshi/page/homepage/classtable/arranged/arranged_page.dart';
import 'package:yidianshi/page/homepage/classtable/not_arranged/not_arranged_page.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';
import 'package:yidianshi/model/xidian_ids/classtable.dart';
import 'package:yidianshi/routes/routes.dart';
import 'package:yidianshi/widget/widget.dart';

class ClassTablePopupMenu extends GetView<ClassTableController> {
  const ClassTablePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'not_arranged',
          child: Text(FlutterI18n.translate(
            context,
            "classtable.popup_menu.not_arranged",
          )),
        ),
        PopupMenuItem(
          value: 'arranged',
          child: Text(FlutterI18n.translate(
            context,
            "classtable.popup_menu.class_changed",
          )),
        ),
        if (!controller.isPartner) ...[
          PopupMenuItem(
            value: 'add_class',
            child: Text(FlutterI18n.translate(
              context,
              "classtable.popup_menu.add_class",
            )),
          ),
          PopupMenuItem(
            value: 'export_ical',
            child: Text(FlutterI18n.translate(
              context,
              "classtable.popup_menu.generate_ical",
            )),
          ),
          PopupMenuItem(
            value: 'export_partner',
            child: Text(FlutterI18n.translate(
              context,
              "classtable.popup_menu.generate_partner_file",
            )),
          ),
          PopupMenuItem(
            value: 'import_partner',
            child: Text(FlutterI18n.translate(
              context,
              "classtable.popup_menu.import_partner_file",
            )),
          ),
          PopupMenuItem(
            value: 'delete_partner',
            child: Text(FlutterI18n.translate(
              context,
              "classtable.popup_menu.delete_partner_file",
            )),
          ),
        ],
      ],
      onSelected: (value) async {
        switch (value) {
          case 'not_arranged':
            Get.to(() => NotArrangedClassList(notArranged: controller.notArranged));
            break;
          case 'arranged':
            Get.to(() => ClassChangeList(classChanges: controller.classChange));
            break;
          case 'add_class':
            final result = await Get.toNamed<(ClassDetail, TimeArrangement)>(Routes.HOME +Routes.CLASSTABLE + Routes.ADD_CLASS);
            if (result != null) {
              await controller.addUserDefinedClass(result.$1, result.$2);
            }
            break;
          // case 'export_ical':
          //   // TODO: Implement iCal export
          //   break;
          // case 'export_partner':
          //   // TODO: Implement partner file export
          //   break;
          // case 'import_partner':
          //   if (context.mounted) {
          //     await (context.findAncestorWidgetOfExactType<ClassTableScreen>() 
          //       ?? const ClassTableScreen())
          //       .importPartnerData(context);
          //   }
            // break;
          case 'delete_partner':
            final confirmed = await Get.dialog<bool>(
              AlertDialog(
                title: Text(FlutterI18n.translate(
                  context,
                  "classtable.partner_classtable.delete_dialog.title",
                )),
                content: Text(FlutterI18n.translate(
                  context,
                  "classtable.partner_classtable.delete_dialog.message",
                )),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text(FlutterI18n.translate(context, "cancel")),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text(FlutterI18n.translate(context, "confirm")),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              controller.deletePartnerClass();
              if (context.mounted) {
                showToast(
                  context: context,
                  msg: FlutterI18n.translate(
                    context,
                    "classtable.partner_classtable.delete_dialog.success_message",
                  ),
                );
              }
            }
            break;
        }
      },
    );
  }
}
