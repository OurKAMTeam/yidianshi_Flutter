import 'package:get/get.dart';
import 'feedback_controller.dart';
import 'feedback_create/feedback_create_controller.dart';

class FeedbackBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackController>(() => FeedbackController());
    Get.lazyPut<FeedbackCreateController>(() => FeedbackCreateController());
  }
}
