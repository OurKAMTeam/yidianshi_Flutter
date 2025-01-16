import 'package:get/get.dart';
import '../../widget/setting/mainpage/data/setting_data.dart';

class SettingController extends GetxController {
  // 用户信息
  final userInfo = SettingData.userInfo.obs;
  
  // 设置项列表
  final settingItems = SettingData.settingItems.obs;

  // 深色模式状态
  final isDarkMode = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  // 加载用户信息
  Future<void> loadUserInfo() async {
    // TODO: 实现从API或本地存储加载用户信息的逻辑
    // 目前使用 SettingData 中的模拟数据
    userInfo.value = SettingData.userInfo;
  }

  // 更新用户信息
  void updateUserInfo(Map<String, dynamic> newInfo) {
    final Map<String, dynamic> updatedInfo = Map.from(userInfo.value);
    updatedInfo.addAll(newInfo);
    userInfo.value = updatedInfo;
  }

  // 切换主题
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
