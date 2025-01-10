import 'package:get/get.dart';
import 'package:yidianshi/widget/home/info_widget/controller/controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Get.put(ApiProvider(), permanent: true);
    // Get.put(ApiRepository(apiProvider: Get.find()), permanent: true);
    Get.put(ClassTableController());
    Get.put(ExamController());
    Get.put(ExperimentController());

  }
}
