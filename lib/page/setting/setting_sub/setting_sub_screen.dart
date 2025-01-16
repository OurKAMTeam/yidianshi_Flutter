import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'setting_sub_controller.dart';
import '../../../widget/setting/setting_sub/widgets/ui_settings_card.dart';
import '../../../widget/setting/setting_sub/widgets/classtable_settings_card.dart';
import '../../../widget/setting/setting_sub/widgets/core_settings_card.dart';

class SettingSubScreen extends GetView<SettingSubController> {
  const SettingSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          UISettingsCard(),
          SizedBox(height: 16),
          ClassTableSettingsCard(),
          SizedBox(height: 16),
          CoreSettingsCard(),
        ],
      ).constrained(maxWidth: 600).center().safeArea(top: true),
    );
  }
}
