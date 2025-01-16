import 'package:get/get.dart';
import 'setting_sub_controller.dart';

class SettingSubBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingSubController());
  }
}
