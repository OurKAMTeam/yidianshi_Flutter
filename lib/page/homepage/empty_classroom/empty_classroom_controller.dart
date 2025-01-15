// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:yidianshi/model/xidian_ids/empty_classroom.dart';
import 'package:yidianshi/xd_api/tool/empty_classroom_session.dart';
import 'package:yidianshi/shared/utils/preference.dart' as preference;

class EmptyClassroomController extends GetxController {
  final isLoading = false.obs;
  final error = ''.obs;
  final places = Rx<List<EmptyClassroomPlace>>([]);
  
  // Search window state
  final isSearching = false.obs;
  final searchError = ''.obs;
  final searchController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final chosenPlace = Rx<EmptyClassroomPlace>(EmptyClassroomPlace(code: '', name: ''));
  final fetchedData = Rx<List<EmptyClassroomData>>([]);
  
  String get semesterCode => preference.getString(preference.Preference.currentSemester);

  List<EmptyClassroomData> get filteredData {
    final searchText = searchController.text;
    if (searchText.isEmpty) return fetchedData.value;
    return fetchedData.value
        .where((data) => data.name.contains(searchText))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchPlaces() async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = await EmptyClassroomSession().getBuildingList();
      places.value = result;
      
      // Initialize chosen place
      String lastChosenClassroom = preference.getString(
        preference.Preference.emptyClassroomLastChoice,
      );
      EmptyClassroomPlace? toGet;
      if (lastChosenClassroom.isNotEmpty) {
        toGet = result.firstWhereOrNull((place) => place.code == lastChosenClassroom);
      }
      chosenPlace.value = toGet ?? result.first;
      
      // Initial data fetch
      updateData();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updateChosenPlace(EmptyClassroomPlace place) {
    chosenPlace.value = place;
    preference.setString(
      preference.Preference.emptyClassroomLastChoice,
      place.code,
    );
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> updateData() async {
    if (chosenPlace.value.code.isEmpty) return;
    
    isSearching.value = true;
    searchError.value = '';
    try {
      int startYear = int.parse(semesterCode.substring(0, 4));
      fetchedData.value = await EmptyClassroomSession().searchData(
        buildingCode: chosenPlace.value.code,
        date: Jiffy.parseFromDateTime(selectedDate.value)
            .format(pattern: "yyyy-MM-dd"),
        semesterRange: "$startYear-${startYear + 1}",
        semesterPart: semesterCode[semesterCode.length - 1],
      );
    } catch (e) {
      searchError.value = e.toString();
    } finally {
      isSearching.value = false;
    }
  }
}
