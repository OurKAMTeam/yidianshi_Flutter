// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/empty_classroom.dart';
import 'package:yidianshi/xd_api/tool/empty_classroom_session.dart';

class EmptyClassroomController extends GetxController {
  final _emptyClassroomSession = EmptyClassroomSession();
  final places = Rxn<List<EmptyClassroomPlace>>();
  final isLoading = true.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    try {
      isLoading.value = true;
      places.value = await _emptyClassroomSession.getBuildingList();
      error.value = '';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<EmptyClassroomData>> searchEmptyClassroom(
    EmptyClassroomPlace place,
    DateTime date,
    int section,
  ) async {
    try {
      // Convert date to required format and calculate semester info
      String dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      String semesterRange = "${date.year}-${date.year + 1}";
      String semesterPart = (date.month >= 9 && date.month <= 2) ? "1" : "2";
      
      return await _emptyClassroomSession.searchData(
        buildingCode: place.code,
        date: dateStr,
        semesterRange: semesterRange,
        semesterPart: semesterPart,
      );
    } catch (e) {
      error.value = e.toString();
      return [];
    }
  }
}
