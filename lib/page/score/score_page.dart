// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0
// Main window for score.

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:yidianshi/page/public_widget/column_choose_dialog.dart';
import 'package:yidianshi/page/public_widget/context_extension.dart';
import 'package:yidianshi/page/public_widget/empty_list_view.dart';
import 'package:yidianshi/page/score/score_info_card.dart';
import 'package:yidianshi/page/score/score_state.dart';
import 'package:yidianshi/page/score/score_statics.dart';
import 'package:yidianshi/shared/utils/preference.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late ScoreState c;
  late TextEditingController text;

  Future<void> scoreInfoDialog(BuildContext context) => context.pushDialog(
        AlertDialog(
          title: Text(FlutterI18n.translate(
            context,
            "score.score_choice.sum_dialog_title",
          )),
          content: Text(
            FlutterI18n.translate(
              context,
              "score.score_choice.sum_dialog_content",
              translationParams: {
                "gpa_all": c.evalAvg(true, isGPA: true).toStringAsFixed(3),
                "avg_all": c.evalAvg(true).toStringAsFixed(2),
                "credit_all": c.evalCredit(true).toStringAsFixed(2),
                "unpassed": c.unPassed.isEmpty
                    ? FlutterI18n.translate(context, "score.all_passed")
                    : c.unPassed,
                "not_core_credit": c.notCoreClass.toString(),
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(FlutterI18n.translate(
                context,
                "confirm",
              )),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );

  @override
  void didChangeDependencies() {
    c = ScoreState.of(context)!;
    c.controllers.addListener(() => mounted ? setState(() {}) : null);
    text = TextEditingController.fromValue(
      TextEditingValue(text: c.controllers.search),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    c.controllers.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> scoreList = List<Widget>.generate(
      c.toShow.length,
      (index) => ScoreInfoCard(
        mark: c.toShow[index].mark,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: Navigator.of(c.context).pop,
        ),
        title: Text(FlutterI18n.translate(
          context,
          "score.score_page.title",
        )),
        actions: [
          if (!getBool(Preference.role))
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () => c.setScoreChoiceMod(),
            ),
        ],
      ),
      body: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              TextField(
                style: const TextStyle(fontSize: 14),
                controller: text,
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: FlutterI18n.translate(
                    context,
                    "score.score_page.search_hint",
                  ),
                ),
                onSubmitted: (String text) => c.search = text,
              ).padding(bottom: 8),
              FilledButton(
                onPressed: () async {
                  await showDialog<int>(
                    context: context,
                    builder: (context) => ColumnChooseDialog(
                      chooseList:
                          ["score.all_semester", ...c.semester].toList(),
                    ),
                  ).then((value) {
                    if (value != null) {
                      c.chosenSemester = ["", ...c.semester].toList()[value];
                    }
                  });
                },
                child: Text(FlutterI18n.translate(
                    context, "score.chosen_semester",
                    translationParams: {
                      "chosen": c.controllers.chosenSemester == ""
                          ? FlutterI18n.translate(
                              context,
                              "score.all_semester",
                            )
                          : c.controllers.chosenSemester,
                    })),
              ).padding(right: 8),
              FilledButton(
                onPressed: () async {
                  await showDialog<int>(
                    context: context,
                    builder: (context) => ColumnChooseDialog(
                      chooseList: ["score.all_type", ...c.statuses].toList(),
                    ),
                  ).then((value) {
                    if (value != null) {
                      c.chosenStatus = ["", ...c.statuses].toList()[value];
                    }
                  });
                },
                child: Text(FlutterI18n.translate(context, "score.chosen_type",
                    translationParams: {
                      "type": c.controllers.chosenStatus == ""
                          ? FlutterI18n.translate(
                              context,
                              "score.all_type",
                            )
                          : c.controllers.chosenStatus,
                    })),
              ),
            ],
          )
              .padding(horizontal: 14, top: 8, bottom: 6)
              .constrained(maxWidth: 480),
          Builder(builder: (context) {
            if (c.toShow.isNotEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => AlignedGridView.count(
                  shrinkWrap: true,
                  itemCount: c.toShow.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  crossAxisCount: constraints.maxWidth ~/ cardWidth,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) => scoreList[index],
                ),
              );
            } else {
              return EmptyListView(
                type: Type.defaultimg,
                text: FlutterI18n.translate(
                  context,
                  "score.score_page.no_record",
                ),
              );
            }
          }).safeArea().expanded(),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: c.controllers.isSelectMod,
        child: BottomAppBar(
          height: 136,
          elevation: 5.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => c.setScoreChoiceState(ChoiceState.all),
                    child: Text(FlutterI18n.translate(
                      context,
                      "score.score_page.select_all",
                    )),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => c.setScoreChoiceState(ChoiceState.none),
                    child: Text(FlutterI18n.translate(
                      context,
                      "score.score_page.select_nothing",
                    )),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () =>
                        c.setScoreChoiceState(ChoiceState.original),
                    child: Text(FlutterI18n.translate(
                      context,
                      "score.score_page.reset_select",
                    )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(c.bottomInfo(context)),
                  FloatingActionButton(
                    elevation: 0.0,
                    highlightElevation: 0.0,
                    focusElevation: 0.0,
                    disabledElevation: 0.0,
                    onPressed: () => scoreInfoDialog(context),
                    child: const Icon(Icons.panorama_fisheye),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
