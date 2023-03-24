import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/logic/util/screen_size.dart';
import 'package:landlearn/ui/component/styled_percent_widget.dart';
import 'package:landlearn/ui/component/word_section_widget.dart';

import '../study.dart';
import '../logic/study_controller.dart';

class ContentWordToggleWidget extends HookConsumerWidget {
  const ContentWordToggleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final show = ref.watch(StudyPage.showContentWordsProvider);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    useEffect(
      () {
        if (show) {
          animationController.forward();
        } else {
          animationController.reverse();
        }

        return null;
      },
      [show],
    );

    Widget child = show
        ? Expanded(
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
              child: const ContentWordWidget(),
            ),
          )
        : openText();

    return child;

    // return AnimatedSize(
    //   key: const Key('content_word_toggle'),
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.fastOutSlowIn,
    //   child: child,
    // );
  }

  Widget openText() {
    return HookConsumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final contentNotifier = ref.read(studyVMProvider).selectedContent;

        useListenable(contentNotifier);

        return SizedBox(
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: 'Total',
                      child: Text(contentNotifier.wordCount.toString()),
                    ),
                    const Text(' '),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(StudyPage.showContentWordsProvider.notifier).state =
                      true;
                },
                child: const RotatedBox(
                  quarterTurns: 1,
                  child: Text('Words', style: TextStyle(fontSize: 20)),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(' '),
                    Tooltip(
                      message: 'Know',
                      child: Text(contentNotifier.wordKnowCount.toString()),
                    ),
                    StyledPercent(
                      awarnessPercent: contentNotifier.awarnessPercent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContentWordWidget extends HookConsumerWidget {
  const ContentWordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.read(studyVMProvider).selectedContent;

    useListenable(contentNotifier);

    final wordCategoris = contentNotifier.wordCategoris;

    return Center(
      child: SizedBox(
        width: 750,
        child: Column(
          children: [
            status(ref, contentNotifier),
            Expanded(
              child: ListView.builder(
                itemCount: wordCategoris.length,
                itemBuilder: (context, index) {
                  final categoryRow = wordCategoris.entries.elementAt(index);

                  return WordSectionWidget(
                    key: Key(categoryRow.key),
                    alphaChar: categoryRow.key,
                    wordCategoryNotifier: categoryRow.value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget status(WidgetRef ref, ContentNotifier contentNotifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Tooltip(
              message: 'Total',
              child: Text(contentNotifier.wordCount.toString()),
            ),
            const Text('/'),
            Tooltip(
              message: 'Know',
              child: Text(contentNotifier.wordKnowCount.toString()),
            ),
            const Text(' '),
            StyledPercent(awarnessPercent: contentNotifier.awarnessPercent),
            const Spacer(),
            if (!screenSize(useContext()).isCompactScreen)
              IconButton(
                icon: const Icon(Icons.toggle_off),
                onPressed: () {
                  ref.read(StudyPage.showContentWordsProvider.notifier).state =
                      !ref.read(StudyPage.showContentWordsProvider);
                },
              ),
          ],
        ),
      ),
    );
  }
}
