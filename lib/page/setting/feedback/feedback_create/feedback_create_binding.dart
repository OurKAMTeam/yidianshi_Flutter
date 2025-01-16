import 'package:get/get.dart';
import 'feedback_create_controller.dart';

class FeedbackCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackCreateController>(
      () => FeedbackCreateController(),
    );
  }
}
