// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_state.dart';
import 'package:yidianshi/page/homepage/classtable/class_page/classtable_page.dart';

/// Intro of the classtable.
class ClassTableWindow extends StatelessWidget {
  final int currentWeek;
  final BuildContext parentContext;
  final BoxConstraints constraints;
  const ClassTableWindow({
    super.key,
    required this.currentWeek,
    required this.parentContext,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return ClassTableState(
      parentContext: parentContext,
      constraints: constraints,
      controllers: ClassTableWidgetState(
        currentWeek: currentWeek,
      ),
      child: const ClassTablePage(),
    );
  }
}
