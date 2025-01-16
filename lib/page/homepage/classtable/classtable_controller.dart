import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yidianshi/shared/utils/logger.dart';
import 'package:yidianshi/shared/utils/pick_file.dart';
import 'package:yidianshi/xd_api/tool/classtable_session.dart';
import 'controller/classtable_state_controller.dart';
import 'package:flutter/material.dart';


class ClassTableController extends ClassTableStateController {
  ClassTableController() : super(currentWeek: int.tryParse(Get.parameters['currentWeek'] ?? '') ?? 1);

  // UI Control variables
  final RxBool isTopRowLocked = false.obs;
  late final PageController pageController;
  late final PageController rowController;

  @override
  void onInit() {
    super.onInit();
    
    // 确保 chosenWeek 在有效范围内
    final initialWeek = int.tryParse(Get.parameters['currentWeek'] ?? '') ?? 1;
    chosenWeek = initialWeek.clamp(1, semesterLength);
    
    // 初始化页面控制器，注意页面索引从0开始
    final initialPage = chosenWeek - 1;
    pageController = PageController(
      initialPage: initialPage,
      keepPage: true,
    );

    // 计算周选择器的视口比例
    final double weekButtonWidth = 48.0;
    final double weekButtonHorizontalPadding = 8.0;
    final double viewportWidth = Get.width;

    rowController = PageController(
      initialPage: initialPage,
      viewportFraction: (weekButtonWidth + 2 * weekButtonHorizontalPadding) / viewportWidth,
      keepPage: true,
    );

    // 监听周数变化
    ever(chosenWeek.obs, (week) {
      if (!isTopRowLocked.value) {
        _switchPage();
      }
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    rowController.dispose();
    super.onClose();
  }

  void lockTopRow(bool lock) {
    isTopRowLocked.value = lock;
  }

  void _switchPage() {
    if (isTopRowLocked.value) return;  // 防止重复触发
    
    isTopRowLocked.value = true;
    
    // 使用 try-finally 确保锁一定会被释放
    try {
      Future.wait([
        rowController.animateToPage(
          chosenWeek - 1,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
        ),
        pageController.animateToPage(
          chosenWeek - 1,
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 300),
        ),
      ]).whenComplete(() => isTopRowLocked.value = false);  // 使用 whenComplete 确保一定会执行
    } catch (e) {
      isTopRowLocked.value = false;  // 发生错误时也要释放锁
      rethrow;
    }
  }

  Future<String?> importPartnerClassFile() async {
    try {
      final result = await pickFile();
      if (result == null) return null;
      final filePath = result.files.single.path;
      if (filePath == null || filePath.isEmpty) return null;
      
      final source = File.fromUri(Uri.parse(filePath)).readAsStringSync();
      final (_, _, _, _, isSuccess) = decodePartnerClass(source);
      
      if (isSuccess) {
        final supportPath = await getApplicationSupportDirectory();
        await File("${supportPath.path}/${ClassTableFile.partnerClassName}")
            .writeAsString(source);
        updatePartnerClass();
        return 'success';
      }
      return 'decode_failed';
    } on MissingStoragePermissionException {
      return 'no_permission';
    } catch (error, stacktrace) {
      log.error(
        "Error occurred while importing partner class.",
        error,
        stacktrace,
      );
      return 'error';
    }
  }
}
