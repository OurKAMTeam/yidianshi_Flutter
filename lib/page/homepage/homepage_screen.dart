// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/widget/home/info_widget/controller/classtable_controller.dart';
import './homepage_controller.dart';

import 'package:yidianshi/widget/widget.dart';
import 'package:yidianshi/routes/routes.dart';

class HomePageScreen extends GetView<HomePageController> {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: GetBuilder<ClassTableControllerMin>(
                builder: (c) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FlutterI18n.translate(context, controller.timeString),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? null
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      c.state == ClassTableState.fetched
                          ? c.getCurrentWeek(updateTime) >= 0 &&
                                  c.getCurrentWeek(updateTime) <
                                      c.classTableData.semesterLength
                              ? FlutterI18n.translate(
                                  context,
                                  "homepage.on_weekday",
                                  translationParams: {
                                    "current":
                                        "${c.getCurrentWeek(updateTime) + 1}"
                                  },
                                )
                              : FlutterI18n.translate(
                                  context,
                                  "homepage.on_holiday",
                                )
                          : c.state == ClassTableState.error
                              ? FlutterI18n.translate(
                                  context,
                                  "homepage.load_error",
                                )
                              : FlutterI18n.translate(
                                  context,
                                  "homepage.loading",
                                ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? null
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: EasyRefresh(
          onRefresh: () {
            showToast(
              context: context,
              msg: FlutterI18n.translate(
                context,
                "homepage.loading_message",
              ),
            );
            controller.updateWithCaptcha(
              context: context,
              sliderCaptcha: (String cookieStr) {
                return SliderCaptchaClientProvider(cookie: cookieStr)
                    .solve(context);
              },
            );
          },
          header: PhoenixHeader(
            skyColor: Theme.of(context).colorScheme.surface,
            position: IndicatorPosition.locator,
            safeArea: true,
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: [
                const HeaderLocator(),
                <Widget>[
                  // const NoticeCard(),
                  // if (prefs.getBool(prefs.Preference.role))
                  //   Text(
                  //     FlutterI18n.translate(
                  //       context,
                  //       "homepage.postgraduate_notice",
                  //     ),
                  //   )
                  //       .center()
                  //       .constrained(height: 30)
                  //       .paddingDirectional(
                  //         horizontal: 16,
                  //         vertical: 14,
                  //       )
                  //       .withHomeCardStyle(context),
                  const ClassTableCard(),
                  ...controller.children,
                  GridView.extent(
                    maxCrossAxisExtent: 96,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...controller.smallFunction,
                    ],
                  ),
                ].toColumn().padding(
                      vertical: 8,
                      horizontal: 16,
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
