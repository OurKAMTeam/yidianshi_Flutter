// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'library_controller.dart';
import 'package:yidianshi/widget/library/borrow_info_card.dart';
import 'package:yidianshi/widget/widget.dart';

class BorrowListWindow extends GetView<LibraryController> {
  const BorrowListWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.getBorrowList(),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.borrowList.value.isEmpty) {
          return EmptyListView(
            type: Type.reading,
            text: FlutterI18n.translate(context, "library.no_borrow"),
          );
        }

        return ListView.builder(
          itemCount: controller.borrowList.value.length,
          itemBuilder: (context, index) {
            final book = controller.borrowList.value[index];
            return BorrowInfoCard(
              toUse: book,
              onRenew: () => controller.renewBook(book.loanId),
            );
          },
        );
      }),
    );
  }
}
