// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:yidianshi/model/xidian_ids/paid_record.dart';
import 'package:yidianshi/widget/public_widget_all/empty_list_view.dart';
import 'package:yidianshi/widget/public_widget_all/public_widget.dart';
import 'package:yidianshi/xd_api/tool/school_card_session.dart';
import 'school_card_controller.dart';

class SchoolCardWindow extends GetView<SchoolCardController> {
  const SchoolCardWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "school_card_window.title")),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshTransactions,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Balance Card
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FlutterI18n.translate(context, "school_card_window.balance"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                            controller.balance.value,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  
                  // Date Range Selector
                  Obx(() => FilledButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(FlutterI18n.translate(
                      context, 
                      "school_card_window.select_range",
                      translationParams: {
                        "startDay": Jiffy.parseFromDateTime(controller.timeRange[0]!)
                            .format(pattern: "yyyy-MM-dd"),
                        "endDay": Jiffy.parseFromDateTime(controller.timeRange[1]!)
                            .format(pattern: "yyyy-MM-dd"),
                      }
                    )),
                    onPressed: () async {
                      final result = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          calendarType: CalendarDatePicker2Type.range,
                          selectedDayHighlightColor: Theme.of(context).colorScheme.primary,
                        ),
                        dialogSize: const Size(324, 400),
                        value: controller.timeRange,
                        borderRadius: BorderRadius.circular(16),
                      );
                      if (result != null) {
                        controller.updateDateRange(result);
                      }
                    },
                  )).padding(horizontal: 16, vertical: 8),

                  // Transaction Summary
                  Obx(() => !controller.isLoading.value && controller.transactions.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                title: FlutterI18n.translate(context, "school_card_window.expense"),
                                amount: controller.totalExpense,
                                isExpense: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SummaryCard(
                                title: FlutterI18n.translate(context, "school_card_window.income"),
                                amount: controller.totalIncome,
                                isExpense: false,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
                  ),
                ],
              ),
            ),

            // Transaction List
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.hasError.value) {
                return SliverFillRemaining(
                  child: ReloadWidget(
                    function: controller.refreshTransactions,
                  ).center(),
                );
              }

              if (controller.transactions.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyListView(
                    type: Type.defaultimg,
                    text: FlutterI18n.translate(
                      context,
                      "school_card_window.no_record",
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final record = controller.transactions[index];
                    final amount = double.parse(record.money);
                    final isExpense = amount > 0;

                    return ListTile(
                      title: Text(record.place),
                      subtitle: Text(record.date),
                      trailing: Text(
                        record.money,
                        style: TextStyle(
                          color: isExpense 
                            ? Theme.of(context).colorScheme.error
                            : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  childCount: controller.transactions.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isExpense;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              amount.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isExpense 
                  ? Theme.of(context).colorScheme.error
                  : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
