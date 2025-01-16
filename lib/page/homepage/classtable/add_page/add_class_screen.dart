import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:styled_widget/styled_widget.dart';
import './add_class_controller.dart';
import 'package:yidianshi/page/homepage/classtable/add_page/wheel_choser.dart';
import 'package:yidianshi/widget/classtable/classtable_constant.dart';

class AddClassScreen extends GetView<AddClassController> {
  const AddClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    const double inputFieldVerticalPadding = 4;
    const double horizontalPadding = 10;

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.onPrimary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );

    Widget weekDoc(int index) {
      return Obx(() => Text((index + 1).toString())
          .textColor(color)
          .center()
          .decorated(
            color: controller.selectedWeeks[index] ? color.withOpacity(0.2) : null,
            borderRadius: const BorderRadius.all(Radius.circular(100.0)),
          )
          .clipOval()
          .gestures(
            onTap: () => controller.toggleWeek(index),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.toChange == null
            ? FlutterI18n.translate(
                context,
                "classtable.class_add.add_class_title",
              )
            : FlutterI18n.translate(
                context,
                "classtable.class_add.change_class_title",
              )),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.validateForm(context)) {
                Get.back(result: controller.getClassData());
              }
            },
            child: Text(FlutterI18n.translate(
              context,
              "classtable.class_add.save_button",
            )),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        children: [
          Column(
            children: [
              TextField(
                controller: controller.nameController,
                decoration: inputDecoration.copyWith(
                  icon: Icon(Icons.calendar_month, color: color),
                  hintText: FlutterI18n.translate(
                    context,
                    "classtable.class_add.input_classname_hint",
                  ),
                ),
              ).padding(vertical: inputFieldVerticalPadding),
              TextField(
                controller: controller.teacherController,
                decoration: inputDecoration.copyWith(
                  icon: Icon(Icons.person, color: color),
                  hintText: FlutterI18n.translate(
                    context,
                    "classtable.class_add.input_teacher_hint",
                  ),
                ),
              ).padding(vertical: inputFieldVerticalPadding),
              TextField(
                controller: controller.locationController,
                decoration: inputDecoration.copyWith(
                  icon: Icon(Icons.place, color: color),
                  hintText: FlutterI18n.translate(
                    context,
                    "classtable.class_add.input_classroom_hint",
                  ),
                ),
              ).padding(vertical: inputFieldVerticalPadding),
            ],
          )
              .padding(vertical: 8, horizontal: 16)
              .card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 0,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month, color: color, size: 16),
                  Text(FlutterI18n.translate(
                    context,
                    "classtable.class_add.input_week_hint",
                  )).textStyle(TextStyle(color: color)).padding(left: 4),
                ],
              ),
              const SizedBox(height: 8),
              GridView.extent(
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                maxCrossAxisExtent: 30,
                children: List.generate(
                  controller.semesterLength,
                  (index) => weekDoc(index),
                ),
              ),
            ],
          ).padding(all: 12).card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 0,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: color, size: 16),
                  Text(FlutterI18n.translate(
                    context,
                    "classtable.class_add.input_time_hint",
                  )).textStyle(TextStyle(color: color)).padding(left: 4),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    children: [
                      Text(FlutterI18n.translate(
                        context,
                        "classtable.class_add.input_time_weekday_hint",
                      )).textStyle(TextStyle(color: color)).center().flexible(),
                      Text(FlutterI18n.translate(
                        context,
                        "classtable.class_add.input_start_time_hint",
                      )).textStyle(TextStyle(color: color)).center().flexible(),
                      Text(FlutterI18n.translate(
                        context,
                        "classtable.class_add.input_end_time_hint",
                      )).textStyle(TextStyle(color: color)).center().flexible(),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => WheelChoose(
                            changeBookIdCallBack: controller.updateWeekday,
                            defaultPage: controller.selectedWeekday.value - 1,
                            options: List.generate(
                              7,
                              (index) => WheelChooseOptions(
                                data: index + 1,
                                hint: getWeekString(context, index),
                              ),
                            ),
                          )).flexible(),
                      Obx(() => WheelChoose(
                            changeBookIdCallBack: controller.updateStartTime,
                            defaultPage: controller.startTime.value - 1,
                            options: List.generate(
                              11,
                              (index) => WheelChooseOptions(
                                data: index + 1,
                                hint: FlutterI18n.translate(
                                  context,
                                  "classtable.class_add.wheel_choose_hint",
                                  translationParams: {
                                    "index": (index + 1).toString(),
                                  },
                                ),
                              ),
                            ),
                          )).flexible(),
                      Obx(() => WheelChoose(
                            changeBookIdCallBack: controller.updateEndTime,
                            defaultPage: controller.endTime.value - 1,
                            options: List.generate(
                              11,
                              (index) => WheelChooseOptions(
                                data: index + 1,
                                hint: FlutterI18n.translate(
                                  context,
                                  "classtable.class_add.wheel_choose_hint",
                                  translationParams: {
                                    "index": (index + 1).toString(),
                                  },
                                ),
                              ),
                            ),
                          )).flexible(),
                    ],
                  ),
                ],
              ),
            ],
          ).padding(all: 12).card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 0,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
        ],
      ),
    );
  }
}
