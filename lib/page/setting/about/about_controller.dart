import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/model/message/message.dart';
import 'package:yidianshi/xd_api/tool/message_session.dart'; // Import message_session.dart

class AboutController extends GetxController {
  final updateMessage = Rxn<UpdateMessage>();

  String get version => "${preference.packageInfo.version}+"
      "${preference.packageInfo.buildNumber}";

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('错误', '无法打开链接');
    }
  }

  Future<bool?> checkUpdates() async {
    try {
      final result = await checkUpdate();
      return result != null;
    } catch (e) {
      return null;
    }
  }

  void openOfficialWebsite() {
    _launchURL('https://your-website.com');
  }

  void openUserAgreement() {
    _launchURL('https://your-website.com/terms');
  }

  void openPrivacyPolicy() {
    _launchURL('https://your-website.com/privacy');
  }
}
