// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:watermeter/page/homepage/info_widget/main_page_card.dart';
import 'package:watermeter/page/public_widget/captcha_input_dialog.dart';
import 'package:watermeter/page/setting/dialogs/electricity_account_dialog.dart';
import 'package:watermeter/repository/preference.dart' as prefs;
import 'package:watermeter/repository/xidian_ids/payment_session.dart';

class ElectricityCard extends StatelessWidget {
  const ElectricityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (prefs.getString(prefs.Preference.dorm).isEmpty) {
          showDialog(
            context: context,
            builder: (context) => ElectricityAccountDialog(),
          ).then((value) {
            if (prefs.getString(prefs.Preference.dorm).isNotEmpty) {
              update(
                captchaFunction: (image) => showDialog<String>(
                  context: context,
                  builder: (context) => CaptchaInputDialog(image: image),
                ).then((value) => value ?? ""),
              );
            }
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text("水电信息"),
              children: [
                Obx(
                  () => Text(
                    "是否为缓存：${isCache}\n"
                    "上次更新时间：${electricityInfo.value.fetchDay}\n"
                    "电费帐号：${PaymentSession.electricityAccount()}\n"
                    "电量信息：${electricityInfo.value.remain.contains(RegExp(r'[0-9]')) ? "度电" : ""}\n"
                    "欠费信息：${electricityInfo.value.owe}\n"
                    "长按可以重新加载，有欠费一般代表水费",
                  ),
                ).paddingSymmetric(horizontal: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("确定"),
                ).paddingSymmetric(horizontal: 24),
              ],
            ),
          );
        }
      },
      onLongPress: () => update(
        captchaFunction: (image) => showDialog<String>(
          context: context,
          builder: (context) => CaptchaInputDialog(image: image),
        ).then((value) => value ?? ""),
      ),
      child: Obx(
        () => MainPageCard(
          isLoad: isLoad.value,
          icon: MingCuteIcons.mgc_flash_line,
          text: "电量信息",
          infoText: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
              children: electricityInfo.value.remain.contains(RegExp(r'[0-9]'))
                  ? [
                      const TextSpan(text: "目前电量 "),
                      TextSpan(
                          text: double.parse(
                        electricityInfo.value.remain,
                      ).truncate().toString()),
                      const TextSpan(text: " 度"),
                    ]
                  : [
                      TextSpan(
                        text: electricityInfo.value.remain,
                      ),
                    ],
            ),
          ),
          bottomText: Text(
            electricityInfo.value.owe,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
