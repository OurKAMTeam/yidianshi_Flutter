import 'package:get/get.dart';
import 'package:yidianshi/widget/home/info_widget/controller/classtable_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/exam_controller.dart';
import 'package:yidianshi/widget/home/info_widget/controller/experiment_controller.dart';
import 'package:yidianshi/page/home/home_controller.dart';
import 'package:yidianshi/page/post/post_controller.dart';
import 'package:yidianshi/page/functions/functions_controller.dart';
import 'package:yidianshi/page/homepage/homepage_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Get.put(ApiProvider(), permanent: true);
    // Get.put(ApiRepository(apiProvider: Get.find()), permanent: true);
    Get.put(ClassTableController());
    Get.put(ExamController());
    Get.put(ExperimentController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<FunctionsController>(() => FunctionsController());
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}
