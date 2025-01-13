import 'package:get/get.dart';
import './testpage_controller.dart';

class TestPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestPageController>(() => TestPageController());
  }
}
