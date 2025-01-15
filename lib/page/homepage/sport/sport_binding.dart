import 'package:get/get.dart';
import 'sport_controller.dart';

class SportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SportController>(() => SportController());
  }
}
