// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'library_controller.dart';
import 'package:yidianshi/widget/library/book_info_card.dart';
import 'package:yidianshi/widget/widget.dart';
import 'package:yidianshi/widget/library/book_detail_card.dart';

class SearchBookWindow extends GetView<LibraryController> {
  const SearchBookWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: FlutterI18n.translate(context, "library.search_here"),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => controller.searchBook(value),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.searchResults.value.isEmpty) {
                if (controller.searchWord.value.isNotEmpty) {
                  return EmptyListView(
                    type: Type.reading,
                    text: FlutterI18n.translate(context, "library.no_result"),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        size: 96,
                      ),
                      const Divider(color: Colors.transparent),
                      Text(FlutterI18n.translate(
                        context,
                        "library.please_search",
                      )),
                    ],
                  );
                }
              }

              return ListView.builder(
                itemCount: controller.searchResults.value.length,
                itemBuilder: (context, index) {
                  final book = controller.searchResults.value[index];
                  return GestureDetector(
                    child: BookInfoCard(toUse: book),
                    onTap: () => BothSideSheet.show(
                      context: context,
                      title: FlutterI18n.translate(
                        context,
                        "library.book_detail",
                      ),
                      child: BookDetailCard(
                        toUse: book,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() => controller.searchResults.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: controller.currentPage.value > 1
                            ? () => controller.searchBook(
                                  controller.searchWord.value,
                                  page: controller.currentPage.value - 1,
                                )
                            : null,
                      ),
                      Text('${controller.currentPage.value}'),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => controller.searchBook(
                          controller.searchWord.value,
                          page: controller.currentPage.value + 1,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
