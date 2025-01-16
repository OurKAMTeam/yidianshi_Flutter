import 'package:get/get.dart';

class FeedbackCategory {
  final String name;
  final RxBool isSelected;

  FeedbackCategory({required this.name, bool selected = false})
      : isSelected = selected.obs;

  static List<FeedbackCategory> getPresetCategories() {
    return [
      FeedbackCategory(name: "论坛", selected: true),  // Default selected
      FeedbackCategory(name: "宣讲会"),
      FeedbackCategory(name: "职位表"),
      FeedbackCategory(name: "招聘公告"),
      FeedbackCategory(name: "竞赛指南"),
      FeedbackCategory(name: "竞赛列表"),
      FeedbackCategory(name: "竞赛打分"),
      FeedbackCategory(name: "保研政策"),
      FeedbackCategory(name: "考研政策"),
      FeedbackCategory(name: "其他问题"),
    ];
  }
}
