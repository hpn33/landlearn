import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/models/content_notifier.dart';

import '../study_controller.dart';

class AppbarWidget extends HookConsumerWidget {
  const AppbarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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
          const SizedBox(width: 10),
          Text(
            'word count\n${contentNotifier.wordCount}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 10),
          toggleViewModeButton(),
          const SizedBox(width: 10),
          TextButton(
            child: const Text('toggle text'),
            onPressed: () {
              ref.read(StudyPage.showContentTextProvider.notifier).state =
                  !ref.read(StudyPage.showContentTextProvider);
            },
          ),
          TextButton(
            child: const Text('toggle words'),
            onPressed: () {
              ref.read(StudyPage.showContentWordsProvider.notifier).state =
                  !ref.read(StudyPage.showContentWordsProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget toggleViewModeButton() {
    const viewModeItems = [
      Tooltip(message: 'Normal', child: Icon(Icons.remove_red_eye)),
      Tooltip(message: 'Clear', child: Icon(Icons.toll_outlined)),
      Tooltip(message: 'Edit', child: Icon(Icons.edit)),
    ];

    return HookConsumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final viewMode = ref.watch(StudyPage.viewModeProvider.notifier);

        final isSelected = useState(
          List.generate(viewModeItems.length, (i) => i == 0),
        );

        return Column(
          children: [
            const Text('View Mode'),
            ToggleButtons(
              children: viewModeItems,
              onPressed: (int index) async {
                isSelected.value =
                    List.generate(viewModeItems.length, (i) => index == i);

                if (viewMode.state == ViewMode.edit &&
                    ref.read(selectedContentStateProvider)!.content !=
                        ref.read(textControllerProvider).text) {
                  ref
                      .read(selectedContentStateProvider)!
                      .updateContent(ref.read(textControllerProvider).text);

                  await analyze(ref);
                }

                viewMode.state = ViewMode.values[index];
              },
              isSelected: isSelected.value,
            ),
          ],
        );
      },
    );
  }
}
