// Copyright 2023 BenderBlog Rodriguez.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermeter/controller/classtable_controller.dart';
import 'package:watermeter/model/xidian_ids/classtable.dart';
import 'package:watermeter/page/classtable/classtable.dart';
import 'package:watermeter/repository/preference.dart' as preference;

class ClassTableCard extends StatelessWidget {
  const ClassTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassTableController>(
      builder: (c) => GestureDetector(
        onTap: () {
          try {
            if (c.isGet == true) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ClassTableWindow(
                    offset: preference.getInt(preference.Preference.swift),
                    classTableData: c.classTableData,
                    currentWeek: c.currentWeek,
                    pretendLayout: c.pretendLayout,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(c.error ?? "正在获取课表")));
            }
          } on String catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("遇到错误：${e.substring(0, 150)}")));
          }
        },
        child: Card(
          elevation: 0,
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      c.isGet == true
                          ? c.isNext == null
                              ? "课程表"
                              : c.isNext == true
                                  ? "课程表 下一节课是："
                                  : "课程表 正在上："
                          : "课程表",
                      style: TextStyle(
                        fontSize: 16,
                        textBaseline: TextBaseline.alphabetic,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      c.isGet == true
                          ? c.classToShow == null
                              ? "目前没课"
                              : c.classToShow!.name
                          : c.error == null
                              ? "正在加载"
                              : "遇到错误",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    )
                  ],
                ),
                c.isGet == true
                    ? c.classToShow == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  "请享受空闲时光",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                )
                              ])
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        c.classToShow!.teacher == null
                                            ? "老师未知"
                                            : c.classToShow!.teacher!.length >=
                                                    7
                                                ? c.classToShow!.teacher!
                                                    .substring(0, 7)
                                                : c.classToShow!.teacher!,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.room,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        c.timeArrangementToShow!.classroom ??
                                            "地点未定",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.access_time_filled_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${time[(c.timeArrangementToShow!.start - 1) * 2]}-"
                                    "${time[(c.timeArrangementToShow!.stop - 1) * 2 + 1]}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                    : Text(
                        c.error == null ? "请耐心等待片刻" : "课表获取失败",
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}