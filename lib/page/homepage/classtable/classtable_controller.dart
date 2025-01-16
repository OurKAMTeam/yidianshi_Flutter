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
    chosenWeek = currentWeek;
    pageController = PageController(
      initialPage: chosenWeek - 1,
      keepPage: true,
    );

    // Calculate viewport fraction for row controller
    final double weekButtonWidth = 48.0; // Adjust this value as needed
    final double weekButtonHorizontalPadding = 8.0; // Adjust this value as needed
    final double viewportWidth = Get.width; // Using Get.width for screen width

    rowController = PageController(
      initialPage: chosenWeek - 1,
      viewportFraction: (weekButtonWidth + 2 * weekButtonHorizontalPadding) / viewportWidth,
      keepPage: true,
    );

    ever(chosenWeek.obs, (_) => _switchPage());
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
    isTopRowLocked.value = true;
    Future.wait(
      [
        rowController.animateToPage(
          chosenWeek,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
        ),
        pageController.animateToPage(
          chosenWeek,
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    ).then((value) => isTopRowLocked.value = false);
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
