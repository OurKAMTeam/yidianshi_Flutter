import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_controller.dart';
import '../../widget/setting/mainpage/widgets/settings_section.dart';
import '../../widget/setting/mainpage/widgets/info_card.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景层 - 个人信息
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.02, 20, 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
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
                                Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InfoCard(
                                      title: '学号',
                                      content: controller.userInfo.value['studentId'] ?? '',
                                    ),
                                    const SizedBox(height: 8),
                                    InfoCard(
                                      title: '学院',
                                      content: controller.userInfo.value['department'] ?? '',
                                    ),
                                    const SizedBox(height: 8),
                                    InfoCard(
                                      title: '专业',
                                      content: controller.userInfo.value['major'] ?? '',
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
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: Container(
              //     color: Colors.grey[100],
              //   ),
              // ),
            ],
          ),
          // 前景层 - 设置部分
          const SettingsSection(),
        ],
      ),
    );
  }
}
