import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:yidianshi/model/xidian_sport/score.dart';
import 'package:yidianshi/model/xidian_sport/sport_class.dart';
import 'package:yidianshi/xd_api/tool/xidian_sport_session.dart';

class SportController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  late EasyRefreshController scoreRefreshController;
  late EasyRefreshController classRefreshController;

  // Score data
  final sportScore = SportScore().obs;
  
  // Class data
  final sportClass = SportClass().obs;

  @override
  void onInit() {
    super.onInit();
    scoreRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    classRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    
    // Initial data loading
    if (sportScore.value.situation == null && sportScore.value.detail.isEmpty) {
      getScore();
    }
    if (sportClass.value.items.isEmpty) {
      getClass();
    }
  }

  @override
  void onClose() {
    scoreRefreshController.dispose();
    classRefreshController.dispose();
    super.onClose();
  }

  Future<void> getScore() async {
    await SportSession().getScore();
  }

  Future<void> getClass() async {
    await SportSession().getClass();
  }
}
