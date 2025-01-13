import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './functions_controller.dart';
import 'package:yidianshi/routes/routes.dart';

class FunctionsScreen extends GetView<FunctionsController> {
  const FunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(
            Routes.HOME + Routes.TESTPAGE,
            preventDuplicates: true,
            id: null,
          );
        },
        child: const Text('跳转到测试页'),
      ),
    );
  }
}
