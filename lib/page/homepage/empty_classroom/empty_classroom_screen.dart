// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/empty_classroom.dart';
import 'package:yidianshi/page/homepage/empty_classroom/empty_classroom_controller.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:yidianshi/page/homepage/empty_classroom/empty_classroom_search_window.dart';

class EmptyClassroomScreen extends GetView<EmptyClassroomController> {
  const EmptyClassroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(
            context,
            "empty_classroom.title",
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CircularProgressIndicator().center();
        }

        if (controller.error.value.isNotEmpty) {
          return ReloadWidget(
            errorStatus: controller.error.value,
            function: controller.fetchPlaces,
          );
        }

        final places = controller.places.value;
        if (places == null || places.isEmpty) {
          return Center(
            child: Text(FlutterI18n.translate(
              context,
              "empty_classroom.no_data",
            )),
          );
        }

        return EmptyClassroomSearchWindow(
          places: places,
        );
      }),
    );
  }
}
