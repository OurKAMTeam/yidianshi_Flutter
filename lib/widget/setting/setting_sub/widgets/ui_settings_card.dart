import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:yidianshi/shared/common/themes/color_seed.dart';
import 'package:yidianshi/widget/widget.dart';
import 'package:yidianshi/widget/setting/setting_sub/change_color_dialog.dart';
import '../../../../page/setting/setting_sub/setting_sub_controller.dart';

class UISettingsCard extends GetView<SettingSubController> {
  const UISettingsCard({Key? key}) : super(key: key);

  Widget _buildListSubtitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<String> demoBlueModeName = [
      FlutterI18n.translate(
        context,
        "setting.change_brightness_dialog.follow_setting",
      ),
      FlutterI18n.translate(
        context,
        "setting.change_brightness_dialog.day_mode",
      ),
      FlutterI18n.translate(
        context,
        "setting.change_brightness_dialog.night_mode",
      ),
    ];

    return ReXCard(
      title: _buildListSubtitle(FlutterI18n.translate(
        context,
        "setting.ui_setting",
      )),
      remaining: const [],
      bottomRow: Column(
        children: [
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.color_setting",
            )),
            subtitle: Obx(() => Text(FlutterI18n.translate(
              context,
              "setting.change_color_dialog.${ColorSeed.values[controller.currentColor.value].label}",
            ))),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ChangeColorDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.brightness_setting",
            )),
            subtitle: Obx(() => Text(
              demoBlueModeName[controller.currentBrightness.value],
            )),
            trailing: Obx(() => ToggleButtons(
              isSelected: List<bool>.generate(
                3,
                (index) => index == controller.currentBrightness.value,
              ),
              onPressed: controller.updateBrightness,
              children: const [
                Icon(Icons.phone_android_rounded),
                Icon(Icons.light_mode_rounded),
                Icon(Icons.dark_mode_rounded),
              ],
            )),
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.simplify_timeline",
            )),
            subtitle: Text(FlutterI18n.translate(
              context,
              "setting.simplify_timeline_description",
            )),
            trailing: Obx(() => Switch(
              value: controller.simplifiedClassTimeline.value,
              onChanged: controller.updateSimplifiedClassTimeline,
            )),
          ),
        ],
      ),
    );
  }
}
