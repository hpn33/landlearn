import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/ui/page/study/study.dart';
import 'package:landlearn/ui/page/study/logic/study_controller.dart';

Future<void> openStudyPage(
  BuildContext context,
  WidgetRef ref,
  ContentNotifier contentNotifier, {
  WordNotifier? selectedWord,
}) async {
  await contentNotifier.updateTime(ref);

  ref.read(studyVMProvider).init(contentNotifier, selectedWord);

  if (context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(builder: (c) => const StudyPage()),
  );

  ref.read(contentHubProvider).notify();
}
