//import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:watermeter/model/xidian_ids/paid_record.dart';
import 'package:watermeter/repository/xidian_ids/school_card_session.dart';

class SchoolCardController extends GetxController {
  var isGet = false.obs;
  RxString error = "".obs;

  SchoolCardSession session = SchoolCardSession();
  // late Future<Uint8List> qrcode;
  var money = "".obs;
  List<DateTime?> timeRange = [];
  var getPaid = <PaidRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    var now = Jiffy.now();
    timeRange = [
      now.startOf(Unit.month).dateTime,
      now.endOf(Unit.month).dateTime,
    ];
  }

  @override
  void onReady() async {
    try {
      isGet.value = false;
      await session.initSession();
      await updateMoney();
      isGet.value = true;
    } on DioException catch (e, s) {
      developer.log(
        "Network exception: ${e.message}\nStack: $s",
        name: "ScoreController",
      );
      error.value = "网络错误，可能是没联网，可能是学校服务器出现了故障:-P";
    } catch (e, s) {
      developer.log(
        "Other exception: $e\nStack: $s",
        name: "ScoreController",
      );
      error.value = "未知错误，感兴趣的话，请接到电脑 adb 查看日志。";
    }
    super.onReady();
  }

  Future<void> refreshPaidRecord() async {
    try {
      error.value = "";
      getPaid.clear();
      getPaid.value = await session.getPaidStatus(
        Jiffy.parseFromDateTime(timeRange[0]!).format(pattern: "yyyy-MM-dd"),
        Jiffy.parseFromDateTime(timeRange[1]!).format(pattern: "yyyy-MM-dd"),
      );
    } catch (e, s) {
      developer.log(e.toString());
      developer.log(s.toString());
      error.value = "凭证过期，重新登录";
    }
    update();
  }

  Future<void> relogin() async => await session.initSession();

  Future<void> updateMoney() async {
    isGet.value = false;
    money.value = await session.getMoney();
    isGet.value = true;
  }
}
