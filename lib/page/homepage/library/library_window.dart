// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'library_controller.dart';
import 'search_book_window.dart';
import 'borrow_list_window.dart';

class LibraryWindow extends GetView<LibraryController> {
  const LibraryWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, "homepage.toolbox.library")),
          bottom: TabBar(
            tabs: [
              Tab(text: FlutterI18n.translate(context, "library.search")),
              Tab(text: FlutterI18n.translate(context, "library.borrow")),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            SearchBookWindow(),
            BorrowListWindow(),
          ],
        ),
      ),
    );
  }
}
