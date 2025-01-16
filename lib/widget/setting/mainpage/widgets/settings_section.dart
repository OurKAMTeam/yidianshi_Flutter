import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/routes/routes.dart';
import 'package:yidianshi/page/setting/setting_controller.dart';

class SettingsSection extends GetView<SettingController> {
  const SettingsSection({Key? key}) : super(key: key);

  Widget _buildSettingRow(IconData icon, String text, String route) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.63,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 4),
                // 第一张卡片
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildSettingRow(Icons.settings_outlined, '设置', Routes.SETTING + Routes.SETTING_SUB),
                          Divider(color: Colors.grey[200], height: 1),
                          _buildSettingRow(Icons.person_outline, '账号绑定', Routes.SETTING + Routes.ACCOUNT),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 第二张卡片
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildSettingRow(Icons.feedback_outlined, '反馈', Routes.SETTING + Routes.FEEDBACK),
                          Divider(color: Colors.grey[200], height: 1),
                          _buildSettingRow(Icons.info_outline, '关于', Routes.SETTING + Routes.ABOUT),
                        ],
                      ),
                    ),
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
