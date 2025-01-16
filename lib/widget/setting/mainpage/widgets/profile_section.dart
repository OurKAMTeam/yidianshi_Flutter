import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../page/setting/setting_controller.dart';

class ProfileSection extends GetView<SettingController> {
  const ProfileSection({Key? key}) : super(key: key);

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 左侧信息部分
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text(
                  '你好！${controller.userInfo.value['name']}！',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
                const SizedBox(height: 20),
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard('学号', controller.userInfo.value['studentId'] ?? ''),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoCard('学院', controller.userInfo.value['department'] ?? ''),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoCard('专业', controller.userInfo.value['major'] ?? ''),
                    ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // 右侧头像部分
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Obx(() => CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(controller.userInfo.value['avatar'] ?? 'assets/icon.png'),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
