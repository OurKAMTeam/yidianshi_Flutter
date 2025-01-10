// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:yidianshi/widget/home/small_function_card.dart';
import 'package:yidianshi/widget/public_widget_all/context_extension.dart';
import 'package:yidianshi/page/toolbox/toolbox_page.dart';

class ToolboxCard extends StatelessWidget {
  const ToolboxCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallFunctionCard(
      onTap: () async {
        context.pushReplacement(const ToolBoxPage());
      },
      icon: MingCuteIcons.mgc_tool_line,
      nameKey: "homepage.toolbox.toolbox",
    );
  }
}
