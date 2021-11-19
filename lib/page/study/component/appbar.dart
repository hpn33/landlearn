import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/analyze_content.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_hub.dart';

import '../study_controller.dart';

class AppbarWidget extends HookConsumerWidget {
  const AppbarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final editMode = ref.watch(StudyPage.editModeProvider.notifier);
    final contentNotifier = ref.read(selectedContentStateProvider)!;

    useListenable(contentNotifier);

    return Material(
      elevation: 6,
      child: Row(
        children: [
          const BackButton(),
          Text(
            'text word\n${contentNotifier.allWordCount}',
            textAlign: TextAlign.center,
          ),
          Text(
            'word count\n${contentNotifier.wordCount}',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            child: const Text('analyze'),
            onPressed: () => analyze(ref),
          ),
          ElevatedButton(
            child: Text(editMode.state ? 'done' : 'edit'),
            onPressed: () async {
              final contentNotifier = ref.read(selectedContentStateProvider)!;

              final textController = ref.read(textControllerProvider);

              if (textController.text != contentNotifier.content) {
                await ref
                    .read(dbProvider)
                    .contentDao
                    .updateContent(contentNotifier.value, textController.text);

                contentNotifier.updateContent(textController.text);
              }

              editMode.state = !editMode.state;
            },
          ),
        ],
      ),
    );
  }

  /// logic

  /// extract work from content text
  void analyze(WidgetRef ref) async {
    final contentNotifier = ref.read(selectedContentStateProvider)!;
    final wordHub = ref.read(wordHubProvider);
    final db = ref.read(dbProvider);

    analyzeContent(db, contentNotifier, wordHub);
  }
}
