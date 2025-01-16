// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:yidianshi/model/xidian_ids/classtable.dart';
import 'package:yidianshi/widget/classtable/class_table_view/class_card.dart';
import 'package:yidianshi/widget/classtable/class_table_view/class_organized_data.dart';
import 'package:yidianshi/widget/classtable/class_table_view/classtable_date_row.dart';
import 'package:yidianshi/widget/classtable/classtable_constant.dart';
//import 'package:yidianshi/page/homepage/classtable/temp_old_page/classtable_state.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';

class ClassTableView extends StatefulWidget {
  final int index;
  final BoxConstraints constraint;

  const ClassTableView({
    super.key,
    required this.constraint,
    required this.index,
  });

  @override
  State<ClassTableView> createState() => _ClassTableViewState();
}

///
/// Classtable blanks below per blocks.
///  * Morning 1-4 each 5 blocks.
///  * Noon break 3 blocks
///  * Afternoon 5-8 each 5 blocks.
///  * Supper time 3 blocks.
///  * Evening time 9-11 each 5 blocks.
/// Total 61 parts, 49 as phone divider.
///
class _ClassTableViewState extends State<ClassTableView> {
  final ClassTableController controller = Get.find<ClassTableController>();

  /// The height of the class card.
  double blockheight(double count) {
    final availableHeight = widget.constraint.minHeight - midRowHeight;
    if (availableHeight <= 0) return 0;  // Safety check for negative height
    final divisor = isPhone(context) ? 48.0 : 61.0;
    return (count * availableHeight / divisor).clamp(0.0, availableHeight);  // Clamp to prevent overflow
  }

  double get blockwidth => (controller.constraints.maxWidth - leftRow) / 7;

  /// The class table are divided into 8 rows, the leftest row is the index row.
  List<Widget> classSubRow(bool isRest) {
    if (isRest) {
      List<Widget> thisRow = [];
      for (var index = 1; index <= 7; ++index) {
        List<ClassOrgainzedData> arrangedEvents =
            controller.getArrangement(
          weekIndex: widget.index,
          dayIndex: index,
        );

        /// Choice the day and render it!
        for (var i in arrangedEvents) {
          /// Generate the row.
          thisRow.add(Positioned(
            top: blockheight(i.start),
            height: blockheight(i.stop - i.start),
            left: leftRow + blockwidth * (index - 1),
            width: blockwidth,
            child: ClassCard(detail: i),
          ));
        }
      }

      if (thisRow.isEmpty &&
          !preference.getBool(preference.Preference.decorated)) {
        thisRow.add(Center(
          child: Column(
            children: [
              SizedBox(height: blockheight(8)),
              Image.asset(
                "assets/art/pda_classtable_empty.png",
                scale: 2,
              ),
              const SizedBox(height: 20),
              ...FlutterI18n.translate(context, "classtable.no_class")
                  .split("\n")
                  .map((e) => Text(e)),
            ],
          ),
        ).padding(left: leftRow));
      }

      return thisRow;
    } else {
      /// Leftest side, the index array.
      return List.generate(13, (index) {
        double height = blockheight(
          index != 4 && index != 9 ? 5 : 3,
        );

        late int indexOfChar;
        if ([0, 1, 2, 3].contains(index)) {
          indexOfChar = index;
        } else if (index == 4) {
          indexOfChar = -1; // noon break
        } else if ([5, 6, 7, 8].contains(index)) {
          indexOfChar = index - 1;
        } else if (index == 9) {
          indexOfChar = -2; // supper break
        } else {
          //if ([10, 11, 12].contains(index))
          indexOfChar = index - 2;
        }

        return DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          child: Text.rich(
            TextSpan(children: [
              if (indexOfChar == -1)
                TextSpan(
                  text: FlutterI18n.translate(
                    context,
                    "classtable.noon_break",
                  ),
                  style: const TextStyle(fontSize: 12),
                )
              else if (indexOfChar == -2)
                TextSpan(
                  text: FlutterI18n.translate(
                    context,
                    "classtable.supper_break",
                  ),
                  style: const TextStyle(fontSize: 12),
                )
              else ...[
                TextSpan(text: "${indexOfChar + 1}\n"),
                TextSpan(
                  text: "${time[indexOfChar * 2]}\n",
                  style: const TextStyle(fontSize: 8),
                ),
                TextSpan(
                  text: time[indexOfChar * 2 + 1],
                  style: const TextStyle(fontSize: 8),
                ),
              ],
            ]),
            textAlign: TextAlign.center,
          ),
        ).center().constrained(
              width: leftRow,
              height: height,
            );
      });
    }
  }

  /// This function will be triggered when user changed class info.
  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  void updateSize() {
    controller.constraints = widget.constraint;
  }

  @override
  void initState() {
    super.initState();
    controller.constraints = widget.constraint;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {}); // Ensure proper layout after frame
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateSize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ClassTableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateSize();
  }

  @override
  Widget build(BuildContext context) {
    return [
      /// The main class table.
      ClassTableDateRow(
        constraints: widget.constraint,
      ),

      /// The rest of the table.
      [
        classSubRow(false)
            .toColumn()
            .decorated(color: Colors.grey.shade200.withOpacity(0.75))
            .constrained(width: leftRow)
            .positioned(left: 0),
        ...classSubRow(true),
      ]
          .toStack()
          .constrained(
            height: blockheight(61),
            width: controller.constraints.maxWidth,
          )
          .scrollable()
          .expanded(),
    ].toColumn();
  }
}
