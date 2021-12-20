import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/ui/page/study/study.dart';
import 'package:landlearn/ui/page/study/study_controller.dart';

Future<void> openStudyPage(
  BuildContext context,
  WidgetRef ref,
  ContentNotifier contentNotifier, {
  WordNotifier? selectedWord,
}) async {
  await contentNotifier.updateTime(ref);

  ref.read(studyVMProvider).init(contentNotifier, selectedWord);

  Navigator.push(
    context,
    MaterialPageRoute(builder: (c) => const StudyPage()),
  );

  ref.read(contentHubProvider).notify();
}
