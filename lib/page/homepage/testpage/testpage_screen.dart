import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'testpage_controller.dart';

class TestPageScreen extends GetView<TestPageController> {
  const TestPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text('HelloWorld'),
      ),
    );
  }
}
