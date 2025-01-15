// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/empty_classroom.dart';
import 'package:yidianshi/page/homepage/empty_classroom/empty_classroom_controller.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';

class EmptyClassroomScreen extends GetView<EmptyClassroomController> {
  const EmptyClassroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "empty_classroom.title")),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.error.value),
                  ElevatedButton(
                    onPressed: controller.fetchPlaces,
                    child: Text(FlutterI18n.translate(context, "general.retry")),
                  ),
                ],
              ),
            );
          }

          final places = controller.places.value;
          if (places == null || places.isEmpty) {
            return Center(
              child: Text(FlutterI18n.translate(context, "empty_classroom.no_data")),
            );
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Card(
                child: ListTile(
                  title: Text(place.name),
                  onTap: () => _showSearchDialog(context, place),
                ),
              ).padding(horizontal: 8, vertical: 4);
            },
          );
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context, EmptyClassroomPlace place) {
    showDialog(
      context: context,
      builder: (context) => EmptyClassroomSearchDialog(
        place: place,
        onSearch: (date, section) async {
          final results = await controller.searchEmptyClassroom(
            place,
            date,
            section,
          );
          if (context.mounted) {
            Get.back();
            _showResults(context, results);
          }
        },
      ),
    );
  }

  void _showResults(BuildContext context, List<EmptyClassroomData> results) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(FlutterI18n.translate(context, "empty_classroom.results")),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final room = results[index];
              return ListTile(
                title: Text(room.name),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(FlutterI18n.translate(context, "general.close")),
          ),
        ],
      ),
    );
  }
}

class EmptyClassroomSearchDialog extends StatefulWidget {
  final EmptyClassroomPlace place;
  final void Function(DateTime date, int section) onSearch;

  const EmptyClassroomSearchDialog({
    super.key,
    required this.place,
    required this.onSearch,
  });

  @override
  State<EmptyClassroomSearchDialog> createState() => _EmptyClassroomSearchDialogState();
}

class _EmptyClassroomSearchDialogState extends State<EmptyClassroomSearchDialog> {
  late DateTime selectedDate;
  int selectedSection = 1;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "empty_classroom.search")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(FlutterI18n.translate(context, "empty_classroom.date")),
            subtitle: Text(selectedDate.toString().split(' ')[0]),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() => selectedDate = date);
              }
            },
          ),
          DropdownButton<int>(
            value: selectedSection,
            items: List.generate(
              12,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}'),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedSection = value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(FlutterI18n.translate(context, "general.cancel")),
        ),
        ElevatedButton(
          onPressed: () => widget.onSearch(selectedDate, selectedSection),
          child: Text(FlutterI18n.translate(context, "general.search")),
        ),
      ],
    );
  }
}
