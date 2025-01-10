// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/empty_classroom.dart';
import 'package:yidianshi/page/empty_classroom/empty_classroom_search_window.dart';
import 'package:yidianshi/page/public_widget/public_widget.dart';
import 'package:yidianshi/repository/xidian_ids/empty_classroom_session.dart';

class EmptyClassroomWindow extends StatefulWidget {
  const EmptyClassroomWindow({super.key});

  @override
  State<EmptyClassroomWindow> createState() => _EmptyClassroomWindowState();
}

class _EmptyClassroomWindowState extends State<EmptyClassroomWindow> {
  late Future<List<EmptyClassroomPlace>> places;

  @override
  void initState() {
    super.initState();
    places = EmptyClassroomSession().getBuildingList();
  }

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
      body: FutureBuilder(
        future: places,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ReloadWidget(
                errorStatus: snapshot.error,
                function: () => setState(() {
                  places = EmptyClassroomSession().getBuildingList();
                }),
              );
            } else {
              return EmptyClassroomSearchWindow(
                places: snapshot.data!,
              );
            }
          } else {
            return const CircularProgressIndicator().center();
          }
        },
      ),
    );
  }
}
