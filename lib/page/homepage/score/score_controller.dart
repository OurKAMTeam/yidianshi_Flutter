// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/score.dart';
import 'package:yidianshi/xd_api/tool/score_session.dart';
import 'package:yidianshi/widget/score/score_statics.dart';

enum ChoiceState { all, none, original }

class ScoreController extends GetxController {
  final ScoreSession scoreSession = ScoreSession();
  final scores = <Score>[].obs;
  final isSelected = <bool>[].obs;
  final isSelectMode = false.obs;
  
  final semesters = <String>{}.obs;
  final statuses = <String>{}.obs;
  final unPassedSet = <String>{}.obs;
  
  final chosenSemester = "".obs;
  final chosenStatus = "".obs;
  final searchText = "".obs;
  final TextEditingController searchController = TextEditingController();
  
  final chosenSemesterInChoice = "".obs;
  final chosenStatusInChoice = "".obs;
  final searchTextInChoice = "".obs;

  final currentDetail = Rxn<List<ComposeDetail>>();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
    fetchScores();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchScores() async {
    try {
      final scoreList = await scoreSession.getScore();
      scores.value = scoreList;
      
      // Initialize selections with proper filtering
      isSelected.value = List.generate(scoreList.length, (int index) {
        for (var i in courseIgnore) {
          if (scores.value[index].name.contains(i)) return false;
        }
        for (var i in typesIgnore) {
          if (scores.value[index].classType.contains(i)) return false;
        }
        return true;
      });
      
      // Extract unique semesters and statuses
      for (var score in scoreList) {
        semesters.add(score.semesterCode);
        statuses.add(score.classStatus);
        if (score.isFinish && !score.isPassed!) {
          unPassedSet.add(score.name);
        }
      }
    } catch (e) {
      debugPrint('Error fetching scores: $e');
    }
  }

  List<Score> get filteredScores {
    if (scores.isEmpty) return [];
    
    return scores.where((score) {
      bool matchesSemester = chosenSemester.value == "" || 
                           chosenSemester.value == "score.all_semester" ||
                           score.semesterCode == chosenSemester.value;
      
      bool matchesStatus = chosenStatus.value == "" ||
                         chosenStatus.value == "score.all_type" ||
                         score.classStatus == chosenStatus.value;
      
      bool matchesSearch = searchText.isEmpty ||
                         score.name.toLowerCase().contains(searchText.toLowerCase());
      
      return matchesSemester && matchesStatus && matchesSearch;
    }).toList();
  }

  void filterScores() {
    if (searchText.isEmpty && 
        (chosenSemester.value == "" || chosenSemester.value == "score.all_semester") && 
        (chosenStatus.value == "" || chosenStatus.value == "score.all_type")) {
      isSelected.value = List.generate(scores.value.length, (_) => true);
      return;
    }

    // Update isSelected based on filtered scores
    final filtered = filteredScores;
    isSelected.value = scores.value.map((score) => 
      filtered.any((s) => s.mark == score.mark)
    ).toList();
    update();
  }

  bool _evalCount(Score eval) => !(
    eval.name.contains("国家英语四级") ||
    eval.name.contains("国家英语六级") ||
    !eval.isFinish ||
    (!eval.isPassed! && !unPassedSet.contains(eval.name)) ||
    (eval.classStatus != "初修" && !eval.isPassed!)
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

  /// Gets the count of non-core classes that are selected and passed
  int get notCoreClass {
    int count = 0;
    for (var i = 0; i < isSelected.length; ++i) {
      if (isSelected[i] && 
          _evalCount(scores.value[i]) && 
          scores.value[i].classType != "必修") {
        count++;
      }
    }
    return count;
  }

  void refresh() => fetchScores();

  void toggleSelectMode() {
    isSelectMode.value = !isSelectMode.value;
  }

  void toggleScoreSelection(int index) {
    isSelected[index] = !isSelected[index];
  }

  void setSelectionState(ChoiceState state) {
    final visibleScores = filteredScores;
    for (var score in visibleScores) {
      int index = scores.indexOf(score);
      if (state == ChoiceState.all) {
        isSelected[index] = true;
      } else if (state == ChoiceState.none) {
        isSelected[index] = false;
      } else {
        bool shouldSelect = true;
        for (var i in courseIgnore) {
          if (score.name.contains(i)) {
            shouldSelect = false;
            break;
          }
        }
        for (var i in typesIgnore) {
          if (score.classType.contains(i)) {
            shouldSelect = false;
            break;
          }
        }
        isSelected[index] = shouldSelect;
      }
    }
  }

  List<Score> getSelectedFilteredScores() {
    return scores.where((score) {
      int index = scores.indexOf(score);
      if (!isSelected[index]) return false;
      
      if (chosenSemesterInChoice.value.isNotEmpty && 
          score.semesterCode != chosenSemesterInChoice.value) {
        return false;
      }
      if (chosenStatusInChoice.value.isNotEmpty && 
          score.classStatus != chosenStatusInChoice.value) {
        return false;
      }
      return score.name.contains(searchTextInChoice.value);
    }).toList();
  }

  double calculateCredits({bool countAll = false}) {
    double total = 0.0;
    for (int i = 0; i < scores.length; i++) {
      if ((isSelected[i] || countAll) && !_shouldExcludeScore(scores[i])) {
        total += scores[i].credit;
      }
    }
    return total;
  }

  double calculateAverage({bool isGPA = false, bool countAll = false}) {
    double totalScore = 0.0;
    double totalCredit = calculateCredits(countAll: countAll);
    
    for (int i = 0; i < scores.length; i++) {
      if ((isSelected[i] || countAll) && !_shouldExcludeScore(scores[i])) {
        totalScore += (isGPA ? scores[i].gpa : scores[i].score!) * 
                     scores[i].credit;
      }
    }
    
    return totalCredit > 0 ? totalScore / totalCredit : 0.0;
  }

  double get nonCoreCourseCredits {
    return scores.fold(0.0, (sum, score) {
      if (score.classStatus.contains(notCoreClassType) && 
          score.isFinish && 
          score.isPassed!) {
        return sum + score.credit;
      }
      return sum;
    });
  }

  String get unpassedCourses => 
      unPassedSet.isEmpty ? "" : unPassedSet.join(",");

  String get unPassed => unPassedSet.join(", ");

  bool _shouldExcludeScore(Score score) {
    return score.name.contains("国家英语四级") ||
           score.name.contains("国家英语六级") ||
           !score.isFinish ||
           (!score.isPassed! && !unPassedSet.contains(score.name)) ||
           (score.classStatus != "初修" && !score.isPassed!);
  }

  void setScoreChoiceFromIndex(int index) {
    if (index >= 0 && index < isSelected.length) {
      isSelected[index] = !isSelected[index];
      update();
    }
  }

  void setScoreChoiceState(ChoiceState state) {
    isSelected.value = List.generate(
      scores.value.length,
      (_) => state == ChoiceState.all ? true : state == ChoiceState.none ? false : false,
    );
  }

  double getCardOpacity(int index, bool isScoreChoice) {
    if ((isSelectMode.value || isScoreChoice) && !isSelected[index]) {
      return 0.38;
    }
    return 1.0;
  }

  String bottomInfo(BuildContext context) {
    double avgScore = evalAvg(false);
    double avgGPA = evalAvg(false, isGPA: true);
    double totalCredit = evalCredit(false);
    
    return 'GPA: ${avgGPA.toStringAsFixed(2)} | Avg: ${avgScore.toStringAsFixed(2)} | Credit: ${totalCredit.toStringAsFixed(1)}';
  }

  Future<List<ComposeDetail>> getScoreDetail(String classId, String semesterCode) async {
    final detail = await scoreSession.getDetail(classId, semesterCode);
    currentDetail.value = detail;
    return detail;
  }
}
