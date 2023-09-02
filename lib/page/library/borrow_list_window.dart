// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

// Borrow list, shows the user's borrowlist.

import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:watermeter/controller/library_controller.dart';
import 'package:watermeter/page/library/borrow_info_card.dart';

class BorrowListWindow extends StatelessWidget {
  const BorrowListWindow({super.key});

  @override
  Widget build(BuildContext context) {
    int crossItems = MediaQuery.sizeOf(context).width ~/ 376;

    int rowItem(int length) {
      int rowItem = length ~/ crossItems;
      if (crossItems * rowItem < length) {
        rowItem += 1;
      }
      return rowItem;
    }

    final LibraryController c = Get.put(LibraryController());
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            elevation: 0,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("仍在借"),
                      Text("${c.notDued} 本"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("已过期"),
                      Text("${c.dued} 本"),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: LayoutGrid(
            columnSizes: repeat(
              crossItems,
              [auto],
            ),
            rowSizes: repeat(
              rowItem(c.borrowList.length),
              [auto],
            ),
            children: List<Widget>.generate(
              c.borrowList.length,
              (index) => BorrowInfoCard(toUse: c.borrowList[index]),
            ),
          ),
        ),
      ],
    );
  }
}
