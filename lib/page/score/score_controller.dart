// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/score.dart';
import 'package:yidianshi/xd_api/tool/score_session.dart';

class ScoreController extends GetxController {
  final scoreSession = ScoreSession();
  final scores = Rx<List<Score>>([]);
  final isLoading = true.obs;
  final error = Rxn<String>();
  
  final semester = RxSet<String>();
  final statuses = RxSet<String>();
  final unPassedSet = RxSet<String>();
  final isSelected = RxList<bool>();
  
  final selectedSemester = RxnString();
  final selectedStatus = RxnString();
  final searchText = ''.obs;
  final isSelectMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchScores();
  }

  Future<void> fetchScores() async {
    try {
      isLoading.value = true;
      error.value = null;
      
      final scoreList = await scoreSession.getScore();
      scores.value = scoreList;
      
      // Initialize selections
      isSelected.value = List.generate(scoreList.length, (_) => true);
      
      // Extract unique semesters and statuses
      for (var score in scoreList) {
        semester.add(score.semesterCode);
        statuses.add(score.scoreStatus);
        if (!score.isPassed!) {
          unPassedSet.add(score.name);
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterScores() {
    if (searchText.isEmpty && selectedSemester.value == null && selectedStatus.value == null) {
      isSelected.value = List.generate(scores.value.length, (_) => true);
      return;
    }

    isSelected.value = scores.value.map((score) {
      bool matchesSemester = selectedSemester.value == null || 
                           selectedSemester.value == "score.all_semester" ||
                           score.semesterCode == selectedSemester.value;
      
      bool matchesStatus = selectedStatus.value == null ||
                         selectedStatus.value == "score.all_type" ||
                         score.scoreStatus == selectedStatus.value;
      
      bool matchesSearch = searchText.isEmpty ||
                         score.name.toLowerCase().contains(searchText.toLowerCase());
      
      return matchesSemester && matchesStatus && matchesSearch;
    }).toList();
  }

  bool _evalCount(Score eval) => !(
    eval.name.contains("国家英语四级") ||
    eval.name.contains("国家英语六级") ||
    !eval.isFinish ||
    (!eval.isPassed! && !unPassedSet.contains(eval.name)) ||
    (eval.scoreStatus != "初修" && !eval.isPassed!)
  );

  double evalCredit(bool isAll) {
    double totalCredit = 0.0;
    for (var i = 0; i < isSelected.length; ++i) {
      if (((isSelected[i] == true && isAll == false) || isAll == true) &&
          _evalCount(scores.value[i])) {
        totalCredit += scores.value[i].credit;
      }
    }
    return totalCredit;
  }

  double evalAvg(bool isAll, {bool isGPA = false}) {
    double totalScore = 0.0;
    double totalCredit = evalCredit(isAll);
    
    for (var i = 0; i < isSelected.length; ++i) {
      if (((isSelected[i] == true && isAll == false) || isAll == true) &&
          _evalCount(scores.value[i])) {
        if (isGPA) {
          totalScore += scores.value[i].credit * scores.value[i].gpa;
        } else {
          totalScore += scores.value[i].credit * (scores.value[i].score ?? 0);
        }
      }
    }
    
    return totalCredit == 0 ? 0 : totalScore / totalCredit;
  }

  void refresh() => fetchScores();

  void toggleSelectMode() {
    isSelectMode.value = !isSelectMode.value;
  }

  void setScoreChoiceFromIndex(int index) {
    if (index >= 0 && index < isSelected.length) {
      isSelected[index] = !isSelected[index];
      update();
    }
  }

  double getCardOpacity(int index, bool isScoreChoice) {
    if ((isSelectMode.value || isScoreChoice) && !isSelected[index]) {
      return 0.38;
    }
    return 1.0;
  }
}
