import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';

import '../study.dart';
import '../study_controller.dart';
import 'edit_view.dart';
import 'read_view.dart';

class ContentTextWidget extends HookConsumerWidget {
  const ContentTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewMode = ref.watch(StudyPage.viewModeProvider);

    return Center(
      child: SizedBox(
        width: 750,
        child: getView(viewMode),
      ),
    );
  }

  Widget getView(ViewMode viewMode) {
    if (viewMode == ViewMode.edit) {
      return const EditView();
    }

    return Column(
      children: [
        selectedWord(),
        const Expanded(child: ReadView()),
      ],
    );
  }

  Widget textView() {
    return HookConsumer(builder: (context, ref, child) {
      final contentNotifier = ref.read(selectedContentProvider)!;

      useListenable(contentNotifier);

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
          child: Text(
            contentNotifier.content,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget selectedWord() => AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: Consumer(
          builder: (context, ref, child) {
            final selectedWordList =
                ref.watch(StudyPage.selectedWordListProvider);

            if (selectedWordList.isEmpty) {
              return Container();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final wordNotifier in selectedWordList)
                    InputChip(
                      deleteIconColor: Colors.grey,
                      onDeleted: () {
                        wordNotifier.setSelection(false);

                        ref
                            .read(StudyPage.selectedWordListProvider.state)
                            .state = [
                          ...selectedWordList..remove(wordNotifier)
                        ];
                      },
                      label: Text(wordNotifier.word),
                    ),
                ],
              ),
            );
          },
        ),
      );
}
