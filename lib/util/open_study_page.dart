import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';

void openStudyPage(
  BuildContext context,
  WidgetRef ref,
  ContentNotifier contentNotifier, {
  WordNotifier? selectedWord,
}) {
  ref.read(selectedContentProvider.state).state = contentNotifier;
  ref.read(StudyPage.selectedWordListProvider.state).state = [];
  ref.read(StudyPage.viewModeProvider.state).state = ViewMode.normal;

  if (selectedWord != null) {
    selectedWord.setSelection(true);

    ref.read(StudyPage.selectedWordListProvider.state).state = [selectedWord];
    ref.read(StudyPage.viewModeProvider.state).state = ViewMode.clearKnowladge;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (c) => const StudyPage()),
  );
}
