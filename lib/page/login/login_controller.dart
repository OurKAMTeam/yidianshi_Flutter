import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:yidianshi/widget/public_widget_all/toast.dart';
import 'package:yidianshi/shared/utils/logger.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;
import 'package:yidianshi/widget/login/jc_captcha.dart';
import 'package:yidianshi/xd_api/base/ehall_session.dart';
import 'package:yidianshi/xd_api/base/ids_session.dart';
import 'package:yidianshi/xd_api/tool/personal_info_session.dart';
import 'package:yidianshi/routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController idsAccountController = TextEditingController();
  final TextEditingController idsPasswordController = TextEditingController();
  
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool _isFirstLogin = true.obs;
  final Rx<IDSLoginState> loginState = IDSLoginState.manual.obs;

  bool get isFirstLogin => _isFirstLogin.value;

  @override
  void onInit() {
    _checkLoginState();
    super.onInit();
    
  }

  void _checkLoginState(){
    String username = preference.getString(preference.Preference.idsAccount);
    String password = preference.getString(preference.Preference.idsPassword);
    _isFirstLogin.value = username.isEmpty || password.isEmpty;
    
    log.info("isFirstLogin: ${_isFirstLogin.value}");


    if (_isFirstLogin.value) {
      loginState.value = IDSLoginState.manual;
      IDSSession().dio.get("https://www.xidian.edu.cn");
    } else {
      // Schedule navigation for after the build phase
      Future.microtask(() => Get.offAllNamed(Routes.HOME));
    }
  }

  @override
  void onClose() {
    idsAccountController.dispose();
    idsPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (idsPasswordController.text.isEmpty) {
      showToast(
        context: Get.context!,
        msg: "请输入密码",
      );
      return;
    }

    isLoading.value = true;
    ProgressDialog pd = ProgressDialog(context: Get.context!);
    pd.show(
      msg: "正在登录",
      max: 100,
      hideValue: true,
    );

    EhallSession ses = EhallSession();
    
    try {
      await ses.clearCookieJar();
    } catch (e) {
      log.warning("[LoginController][login] No clear state.");
    }

    try {
      await ses.loginEhall(
        username: idsAccountController.text,
        password: idsPasswordController.text,
        onResponse: (int number, String status) {
          pd.update(value: number, msg: status);
        },
        sliderCaptcha: (String cookieStr) =>
            SliderCaptchaClientProvider(cookie: cookieStr).solve(null),
      );

            pd.update(value: 75, msg: "正在保存账号密码");
      await preference.setString(
        preference.Preference.idsAccount,
        idsAccountController.text,
      );
      await preference.setString(
        preference.Preference.idsPassword,
        idsPasswordController.text,
      );

      pd.update(value: 50, msg: "正在获取个人信息");
      bool isPostGraduate = await ses.checkWhetherPostgraduate();
      if (isPostGraduate) {
        await PersonalInfoSession().getInformationFromYjspt();
      } else {
        await PersonalInfoSession().getInformationEhall();
      }



      pd.close();
      isLoading.value = false;
      Get.toNamed(Routes.HOME);
      
    } catch (e) {
      pd.close();
      isLoading.value = false;
      if (e is PasswordWrongException) {
        showToast(
          context: Get.context!,
          msg: e.msg,
        );
      } else if (e is LoginFailedException) {
        showToast(
          context: Get.context!,
          msg: e.msg,
        );
      } else if (e is DioException) {
        if (e.message == null) {
          if (e.response == null) {
            showToast(
              context: Get.context!,
              msg: "无法连接到服务器",
            );
          } else {
            showToast(
              context: Get.context!,
              msg: "登录失败，错误代码：${e.response!.statusCode}",
            );
          }
        } else {
          showToast(
            context: Get.context!,
            msg: "登录失败：${e.message}",
          );
        }
      } else {
        log.warning("[LoginController][login] Login failed with error: $e");
        showToast(
          context: Get.context!,
          msg: "登录失败，请稍后重试",
        );
      }
    }
  }
}
