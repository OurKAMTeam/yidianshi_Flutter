import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yidianshi/shared/shared.dart';
import 'package:yidianshi/widget/widget.dart';
import '../../../../page/setting/setting_sub/setting_sub_controller.dart';

class CoreSettingsCard extends GetView<SettingSubController> {
  const CoreSettingsCard({Key? key}) : super(key: key);

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
    return ReXCard(
      title: _buildListSubtitle(FlutterI18n.translate(
        context,
        "setting.core_setting",
      )),
      remaining: const [],
      bottomRow: Column(
        children: [
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.check_logger",
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => context.push(TalkerScreen(talker: log)),
          ),
          const Divider(),
          ListTile(
            title: Text(FlutterI18n.translate(
              context,
              "setting.clear_and_restart",
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(FlutterI18n.translate(
                  context,
                  "setting.clear_and_restart_dialog.title",
                )),
                content: Text(FlutterI18n.translate(
                  context,
                  "setting.clear_and_restart_dialog.content",
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
                    onPressed: () async {
                      ProgressDialog pd = ProgressDialog(context: context);
                      pd.show(
                        msg: FlutterI18n.translate(
                          context,
                          "setting.clear_and_restart_dialog.cleaning",
                        ),
                      );
                      await controller.clearCache();
                      if (context.mounted) {
                        showToast(
                          context: context,
                          msg: FlutterI18n.translate(
                            context,
                            "setting.clear_and_restart_dialog.clear",
                          ),
                        );
                      }
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
              "setting.logout",
            )),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(FlutterI18n.translate(
                  context,
                  "setting.logout_dialog.title",
                )),
                content: Text(FlutterI18n.translate(
                  context,
                  "setting.logout_dialog.content",
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
                    onPressed: () async {
                      ProgressDialog pd = ProgressDialog(context: context);
                      pd.show(
                        msg: FlutterI18n.translate(
                          context,
                          "setting.logout_dialog.logging_out",
                        ),
                      );
                      await controller.logout();
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
        ],
      ),
    );
  }
}
