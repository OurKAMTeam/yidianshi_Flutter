import 'package:get/get.dart';
import 'package:yidianshi/model_db/feedback/feedback.dart';
import 'package:yidianshi/xd_api/tool/message_session.dart';

class FeedbackController extends GetxController {
  final feedbacks = <Feedback>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    try {
      isLoading.value = true;
      // TODO: Replace with actual API call
      // final result = await MessageSession.getFeedbacks();
      // feedbacks.value = result;
      
      // Temporary mock data
      feedbacks.value = [
        Feedback(
          id: '1',
          content: '希望能添加更多的功能',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          status: FeedbackStatus.inProgress,
        ),
        Feedback(
          id: '2',
          content: '界面很好看，继续加油',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          status: FeedbackStatus.resolved,
        ),
      ];
    } catch (e) {
      Get.snackbar('错误', '获取反馈列表失败');
    } finally {
      isLoading.value = false;
    }
  }
}
