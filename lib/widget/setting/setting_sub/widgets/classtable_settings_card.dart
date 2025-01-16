import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:yidianshi/shared/shared.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/widget/widget.dart';
import 'package:yidianshi/xd_api/tool/classtable_session.dart';
import 'package:yidianshi/xd_api/base/network_session.dart';
import 'package:yidianshi/widget/home/info_widget/controller/classtable_controller.dart';
import '../../../../page/setting/setting_sub/setting_sub_controller.dart';
import '../change_swift_dialog.dart';



class ClassTableSettingsCard extends GetView<SettingSubController> {
  const ClassTableSettingsCard({Key? key}) : super(key: key);

  Widget _buildListSubtitle(String text) => Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
    return ReXCard(
      title: _buildListSubtitle(FlutterI18n.translate(
        context,
        "setting.classtable_setting",
      )),
      remaining: const [],
      bottomRow: Column(
        children: [
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.background",
            )),
            trailing: Obx(() => Switch(
              value: controller.decorated.value,
              onChanged: (bool value) {
                if (value == true && !controller.decoration.value) {
                  showToast(
                    context: context,
                    msg: FlutterI18n.translate(
                      context,
                      "setting.no_background",
                    ),
                  );
                } else {
                  controller.updateDecorated(value);
                }
              },
            )),
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.choose_background",
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () async {
              FilePickerResult? result;
              try {
                result = await pickFile(type: FileType.image);
              } on MissingStoragePermissionException {
                if (context.mounted) {
                  showToast(
                    context: context,
                    msg: FlutterI18n.translate(
                      context,
                      "setting.no_permission",
                    ),
                  );
                }
              }
              if (context.mounted) {
                if (result != null) {
                  File(result.files.single.path!).copySync(
                      "${supportPath.path}/${ClassTableFile.decorationName}");
                  preference.setBool(preference.Preference.decoration, true);
                  if (context.mounted) {
                    showToast(
                      context: context,
                      msg: FlutterI18n.translate(
                        context,
                        "setting.successful_setting",
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showToast(
                      context: context,
                      msg: FlutterI18n.translate(
                        context,
                        "setting.failure_setting",
                      ),
                    );
                  }
                }
              }
            },
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.clear_user_class",
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(FlutterI18n.translate(
                  context,
                  "setting.clear_user_class_title",
                )),
                content: Text(FlutterI18n.translate(
                  context,
                  "setting.clear_user_class_content",
                )),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(FlutterI18n.translate(
                      context,
                      "cancel",
                    )),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearUserClass();
                      showToast(
                        context: context,
                        msg: FlutterI18n.translate(
                          context,
                          "setting.clear_user_class_clear",
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text(FlutterI18n.translate(
                      context,
                      "confirm",
                    )),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.class_refresh",
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(FlutterI18n.translate(
                  context,
                  "setting.class_refresh_title",
                )),
                content: Text(FlutterI18n.translate(
                  context,
                  "setting.class_refresh_content",
                )),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(FlutterI18n.translate(
                      context,
                      "cancel",
                    )),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.refreshClassTable();
                      Navigator.pop(context);
                    },
                    child: Text(FlutterI18n.translate(
                      context,
                      "confirm",
                    )),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.class_swift",
            )),
            subtitle: Obx(() => Text(
              FlutterI18n.translate(
                context,
                "setting.class_swift_description",
                translationParams: {
                  "swift": controller.swift.value.toString(),
                },
              ),
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => ChangeSwiftDialog(),
              ).then((value) {
                Get.find<ClassTableControllerMin>().update();
                updateCurrentData();
                controller.swift.value = preference.getInt(preference.Preference.swift);
              });
            },
          ),
        ],
      ),
    );
  }
}
