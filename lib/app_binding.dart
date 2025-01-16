import 'package:get/get.dart';
import 'package:yidianshi/widget/home/info_widget/controller/classtable_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/experiment_controller.dart';
import 'package:yidianshi/page/home/home_controller.dart';
import 'package:yidianshi/page/post/post_controller.dart';
import 'package:yidianshi/page/functions/functions_controller.dart';
import 'package:yidianshi/page/homepage/homepage_controller.dart';
import 'package:yidianshi/page/homepage/classtable/controller/classtable_state_controller.dart';
import 'package:yidianshi/page/setting/setting_controller.dart';
import 'package:yidianshi/page/setting/setting_sub/setting_sub_controller.dart';
import 'package:yidianshi/page/setting/account/account_controller.dart';
import 'package:yidianshi/page/setting/feedback/feedback_controller.dart';
import 'package:yidianshi/page/setting/about/about_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Get.put(ApiProvider(), permanent: true);
    // Get.put(ApiRepository(apiProvider: Get.find()), permanent: true);
    Get.put(ClassTableControllerMin());
    Get.put(ExamController());
    Get.put(ExperimentController());
    Get.lazyPut<ClassTableStateController>(() => ClassTableStateController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<FunctionsController>(() => FunctionsController());
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<SettingController>(() => SettingController());
    Get.put(SettingSubController());
    Get.put(AccountController());
    Get.put(FeedbackController());
    Get.put(AboutController());
  }
}
