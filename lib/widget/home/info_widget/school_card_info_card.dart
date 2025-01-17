// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'dart:math';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/widget/public_widget_all/toast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yidianshi/widget/home/main_page_card.dart';
import 'package:yidianshi/widget/public_widget_all/context_extension.dart';
import 'package:yidianshi/page/homepage/schoolcard/school_card_window.dart';
import 'package:yidianshi/xd_api/base/network_session.dart';
import 'package:yidianshi/xd_api/tool/school_card_session.dart'
    as school_card_session;
import 'package:yidianshi/xd_api/base/ids_session.dart';

import 'package:ming_cute_icons/ming_cute_icons.dart';

class SchoolCardInfoCard extends StatelessWidget {
  const SchoolCardInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (offline) {
          showToast(
            context: context,
            msg: FlutterI18n.translate(
              context,
              "homepage.offline_mode",
            ),
          );
        } else {
          switch (school_card_session.isInit.value) {
            case SessionState.fetched:
              context.pushReplacement(const SchoolCardWindow());
              break;
            case SessionState.error:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(school_card_session.errorSession.substring(
                    0,
                    min(
                      school_card_session.errorSession.value.length,
                      120,
                    ),
                  )),
                ),
              );

              showToast(
                context: context,
                msg: FlutterI18n.translate(
                  context,
                  "homepage.school_card_info_card.error_toast",
                ),
              );
              break;
            default:
              showToast(
                context: context,
                msg: FlutterI18n.translate(
                  context,
                  "homepage.school_card_info_card.fetching_toast",
                ),
              );
          }
        }
      },
      child: Obx(
        () => MainPageCard(
          isLoad: school_card_session.isInit.value == SessionState.fetching,
          icon: MingCuteIcons.mgc_wallet_4_line,
          text: FlutterI18n.translate(
            context,
            "homepage.school_card_info_card.bill",
          ),
          infoText: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 20),
              children: [
                if (school_card_session.isInit.value ==
                    SessionState.fetched) ...[
                  if (school_card_session.SchoolCardSession.money.value
                      .contains(RegExp(r'[0-9]')))
                    TextSpan(
                      text: FlutterI18n.translate(
                          context, "homepage.school_card_info_card.balance",
                          translationParams: {
                            "amount": double.parse(
                                      school_card_session.SchoolCardSession.money.value,
                                    ) >=
                                    10
                                ? double.parse(school_card_session.SchoolCardSession.money.value)
                                    .truncate()
                                    .toString()
                                : school_card_session.SchoolCardSession.money.value,
                          }),
                    )
                  else
                    TextSpan(
                      text: FlutterI18n.translate(
                        context,
                        school_card_session.SchoolCardSession.money.value,
                      ),
                    ),
                ] else
                  TextSpan(
                    text: school_card_session.isInit.value == SessionState.error
                        ? FlutterI18n.translate(
                            context,
                            "homepage.school_card_info_card.error_occured",
                          )
                        : FlutterI18n.translate(
                            context,
                            "homepage.school_card_info_card.fetching",
                          ),
                  ),
              ],
            ),
          ),
          bottomText: Text(
            school_card_session.isInit.value == SessionState.fetched
                ? FlutterI18n.translate(
                    context,
                    "homepage.school_card_info_card.bottom_text_success",
                  )
                : school_card_session.isInit.value == SessionState.error
                    ? FlutterI18n.translate(
                        context,
                        "homepage.school_card_info_card.no_info",
                      )
                    : FlutterI18n.translate(
                        context,
                        "homepage.school_card_info_card.fetching_info",
                      ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}