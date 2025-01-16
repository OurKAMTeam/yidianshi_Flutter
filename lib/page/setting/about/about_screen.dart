import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yidianshi/widget/widget.dart';
import 'about_controller.dart';
import 'package:yidianshi/widget/setting/about/update_dialog.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text(FlutterI18n.translate(context, "setting.about")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Logo
            Image.asset(
              'assets/icon.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            // Card
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Get.theme.primaryColor),
                    title: Text(FlutterI18n.translate(
                      context,
                      "setting.about_this_program",
                    )),
                    subtitle: Text(
                      FlutterI18n.translate(
                        context,
                        "setting.version",
                        translationParams: {
                          "version": controller.version,
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.system_update, color: Get.theme.primaryColor),
                    title: Text(FlutterI18n.translate(
                      context,
                      "setting.check_update",
                    )),
                    subtitle: Obx(() => Text(
                      FlutterI18n.translate(
                        context,
                        "setting.latest_version",
                        translationParams: {
                          "latest": controller.updateMessage.value?.code ??
                              FlutterI18n.translate(
                                context,
                                "setting.waiting",
                              ),
                        },
                      ),
                    )),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      showToast(
                        context: context,
                        msg: FlutterI18n.translate(
                          context,
                          "setting.fetching_update",
                        ),
                      );
                      controller.checkUpdates().then((value) async {
                        if (context.mounted) {
                          if ((value ?? false) && controller.updateMessage.value != null) {
                            await showDialog(
                              context: context,
                              builder: (context) => Obx(
                                () => UpdateDialog(
                                  updateMessage: controller.updateMessage.value!,
                                ),
                              ),
                            );
                          } else {
                            showToast(
                              context: context,
                              msg: FlutterI18n.translate(
                                context,
                                value == null
                                    ? "setting.current_testing"
                                    : "setting.current_stable",
                              ),
                            );
                          }
                        }
                      }, onError: (e, s) {
                        if (context.mounted) {
                          showToast(
                            context: context,
                            msg: FlutterI18n.translate(
                              context,
                              "setting.fetch_failed",
                            ),
                          );
                        }
                      });
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.language, color: Get.theme.primaryColor),
                    title: Text("官方网站"),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: controller.openOfficialWebsite,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.description, color: Get.theme.primaryColor),
                    title: Text("用户协议"),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: controller.openUserAgreement,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.privacy_tip, color: Get.theme.primaryColor),
                    title: Text("隐私政策"),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: controller.openPrivacyPolicy,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
