// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:yidianshi/model/xidian_ids/paid_record.dart';
import 'package:yidianshi/xd_api/tool/school_card_session.dart';

class SchoolCardController extends GetxController {
  final RxList<DateTime?> timeRange = <DateTime?>[].obs;
  final RxList<PaidRecord> transactions = <PaidRecord>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString balance = '0.00'.obs;
  
  @override
  void onInit() {
    super.onInit();
    var now = Jiffy.now();
    timeRange.value = [
      now.startOf(Unit.month).dateTime,
      now.dateTime,
    ];
    refreshTransactions();
  }

  Future<void> refreshTransactions() async {
    if (timeRange.length != 2 || timeRange[0] == null || timeRange[1] == null) {
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final session = SchoolCardSession();
      final records = await session.getPaidStatus(
        Jiffy.parseFromDateTime(timeRange[0]!).format(pattern: "yyyy-MM-dd"),
        Jiffy.parseFromDateTime(timeRange[1]!).format(pattern: "yyyy-MM-dd"),
      );
      transactions.value = records;
      
      // Get current balance
      try {
        await session.initSession();
        balance.value = SchoolCardSession.money.value;
      } catch (e) {
        // If balance fetch fails, don't update the balance
        print('Failed to fetch balance: $e');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  double get totalExpense {
    double total = 0;
    for (var record in transactions) {
      final amount = double.parse(record.money);
      if (amount > 0) {
        total += amount;
      }
    }
    return total;
  }

  double get totalIncome {
    double total = 0;
    for (var record in transactions) {
      final amount = double.parse(record.money);
      if (amount < 0) {
        total += amount.abs();
      }
    }
    return total;
  }

  void updateDateRange(List<DateTime?> newRange) {
    if (newRange.length == 1) {
      timeRange.value = [newRange[0], newRange[0]];
    } else if (newRange.length == 2) {
      timeRange.value = newRange;
    }
    refreshTransactions();
  }
}
