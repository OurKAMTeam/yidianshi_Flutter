import 'package:get/get.dart';
import 'package:yidianshi/page/homepage/classtable/classtable_controller.dart';

class ClassTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassTableController>(() => ClassTableController());
  }
}
