import 'package:get/get.dart';
import './functions_controller.dart';

class FunctionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FunctionsController>(() => FunctionsController());
  }
}
