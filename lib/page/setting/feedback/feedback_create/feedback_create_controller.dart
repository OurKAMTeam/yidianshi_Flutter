import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yidianshi/page/setting/feedback/feedback_controller.dart';
import 'feedback_category.dart';

class FeedbackCreateController extends GetxController {
  final contentController = TextEditingController();
  final categories = FeedbackCategory.getPresetCategories();
  final selectedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  final isSubmitting = false.obs;

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitFeedback() async {
    final selectedCategories = categories
        .where((category) => category.isSelected.value)
        .map((category) => category.name)
        .toList();

    if (selectedCategories.isEmpty) {
      Get.snackbar('提示', '请至少选择一个反馈类型');
      return;
    }

    if (contentController.text.trim().isEmpty) {
      Get.snackbar('提示', '请输入反馈内容');
      return;
    }

    try {
      isSubmitting.value = true;
      // TODO: Replace with actual API call
      // await MessageSession.submitFeedback(
      //   content: contentController.text,
      //   categories: selectedCategories,
      //   images: selectedImages,
      // );
      
      Get.back();
      Get.snackbar('成功', '感谢您的反馈！');
      
      // Refresh feedback list
      Get.find<FeedbackController>().fetchFeedbacks();
    } catch (e) {
      Get.snackbar('错误', '提交反馈失败');
    } finally {
      isSubmitting.value = false;
    }
  }
}
