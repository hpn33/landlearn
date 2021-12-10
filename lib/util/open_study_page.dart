import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  if (selectedWord != null) {
    selectedWord.setSelection(true);

    ref.read(StudyPage.selectedWordListProvider.state).state = [selectedWord];
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (c) => const StudyPage()),
  );
}
