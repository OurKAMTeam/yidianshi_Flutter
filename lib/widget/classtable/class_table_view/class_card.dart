// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR  Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/classtable.dart';
import 'package:yidianshi/model/xidian_ids/exam.dart';
import 'package:yidianshi/model/xidian_ids/experiment.dart';
//import 'package:yidianshi/page/homepage/classtable/add_page/class_add_window.dart';
import 'package:yidianshi/widget/classtable/class_table_view/class_organized_data.dart';
import 'package:yidianshi/widget/classtable/arrangement_detail/arrangement_detail.dart';
//import 'package:yidianshi/page/homepage/classtable/temp_old_page/classtable_state.dart';
import 'package:yidianshi/widget/public_widget_all/both_side_sheet.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';
import 'package:yidianshi/routes/routes.dart';

/// The card in [classSubRow], metioned in [ClassTableView].
class ClassCard extends StatelessWidget {
  final ClassOrgainzedData detail;

  List<dynamic> get data => detail.data;
  MaterialColor get color => detail.color;
  String get name => detail.name;
  String? get place => detail.place;
  const ClassCard({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final classTableController = Get.find<ClassTableController>();

    /// This is the result of the class info card.
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        // Out
        borderRadius: BorderRadius.circular(8),
        child: Container(
          // Border
          color: color.shade300.withOpacity(0.8),
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: [
              ClipRRect(
                // Inner
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  color: color.shade100.withOpacity(0.7),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      /// The way to show the class info of the period.
                      /// The last one indicate whether to delete this stuff.
                      (ClassDetail, TimeArrangement, bool)? toUse =
                          await BothSideSheet.show(
                        title: FlutterI18n.translate(
                          context,
                          "classtable.class_card.title",
                        ),
                        child: ArrangementDetail(
                          information: List.generate(data.length, (index) {
                            if (data.elementAt(index) is Subject ||
                                data.elementAt(index) is ExperimentData) {
                              return data.elementAt(index);
                            } else {
                              return (
                                classTableController.getClassDetail(
                                  classTableController.timeArrangement
                                      .indexOf(data.elementAt(index)),
                                ),
                                data.elementAt(index),
                              );
                            }
                          }),
                          currentWeek: classTableController.currentWeek,
                        ),
                        context: context,
                      );
                      if (context.mounted && toUse != null) {
                        if (toUse.$3) {
                          await classTableController
                              .deleteUserDefinedClass(toUse.$2);
                        } else {
                          final result = await Get.toNamed<(ClassDetail, TimeArrangement, TimeArrangement)>(
                            Routes.HOME + Routes.CLASSTABLE + Routes.ADD_CLASS,
                            arguments: {
                              'toChange': (toUse.$1, toUse.$2),
                              'semesterLength': classTableController.semesterLength,
                            },
                          );
                          if (result != null) {
                            await classTableController.editUserDefinedClass(
                              result.$2,  // oldTimeArrangement
                              result.$1,  // classDetail
                              result.$3,  // newTimeArrangement
                            );
                          }
                        }
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color.shade900,
                            fontSize: isPhone(context) ? 12 : 14,
                          ),
                        ),
                        Text(
                          "@${place ?? FlutterI18n.translate(
                                context,
                                "classtable.class_card.unknown_classroom",
                              )}",
                          style: TextStyle(
                            color: color.shade900,
                            fontSize: isPhone(context) ? 10 : 12,
                          ),
                        ).expanded(),
                        if (data.length > 1)
                          Text(
                            FlutterI18n.translate(
                              context,
                              "classtable.class_card.remains_hint",
                              translationParams: {
                                "remain_count": (data.length - 1).toString(),
                              },
                            ),
                            style: TextStyle(
                              color: color.shade900,
                              fontSize: isPhone(context) ? 10 : 12,
                            ),
                          ),
                      ],
                    ).alignment(Alignment.topLeft).padding(
                          horizontal: isPhone(context) ? 2 : 4,
                          vertical: 4,
                        ),
                  ),
                ),
              ),
              if (data.length > 1)
                ClipPath(
                  clipper: Triangle(),
                  child: Container(
                    color: color.shade300,
                  ).constrained(
                    width: 8,
                    height: 8,
                  ),
                ).alignment(Alignment.topRight),
            ],
          ),
        ),
      ),
    );
  }
}

class Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      const Offset(0, 0),
      Offset(size.width, 0),
      Offset(size.width, size.height),
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
