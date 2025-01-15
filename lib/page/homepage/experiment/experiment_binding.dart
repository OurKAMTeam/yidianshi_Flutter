import 'package:get/get.dart';
import 'experiment_controller.dart';

class ExperimentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExperimentPageController>(() => ExperimentPageController());
  }
}
