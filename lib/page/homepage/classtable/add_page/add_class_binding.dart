import 'package:get/get.dart';
import './add_class_controller.dart';

class AddClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddClassController>(() => AddClassController(
          semesterLength: Get.arguments['semesterLength'] as int,
          toChange: Get.arguments['toChange'] as (ClassDetail, TimeArrangement)?,
        ));
  }
}
