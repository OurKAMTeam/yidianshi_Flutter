import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/model_db/feedback/feedback.dart' as model;
import 'feedback_controller.dart';
import 'package:yidianshi/routes/routes.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text('反馈'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchFeedbacks(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.feedbacks.isEmpty) {
            return const Center(
              child: Text(
                '无反馈记录',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.feedbacks.length,
            itemBuilder: (context, index) {
              final model.Feedback feedback = controller.feedbacks[index];
              return _FeedbackCard(feedback: feedback);
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.SETTING + Routes.FEEDBACK + Routes.FEEDBACK_CREATE),
        icon: const Icon(Icons.add_comment),
        label: const Text('欢迎提出建议和反馈'),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final model.Feedback feedback;

  const _FeedbackCard({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isResolved = feedback.status == model.FeedbackStatus.resolved;
    final statusColor = isResolved ? Colors.green : Colors.red;
    final statusText = isResolved ? '已解决' : '改进中';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedback.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  feedback.timestamp.toString().substring(0, 16),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
