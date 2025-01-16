import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text('账号绑定'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
