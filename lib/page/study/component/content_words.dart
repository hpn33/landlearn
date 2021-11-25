import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/widget/word_section_widget.dart';

import '../study_controller.dart';

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
      },
      [show],
    );

    useEffect(() {
      return animationController.dispose;
    }, []);

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
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return SizedBox(
          width: 50,
          child: Center(
            child: TextButton(
              onPressed: () {
                ref.read(StudyPage.showContentWordsProvider.state).state = true;
              },
              child: const RotatedBox(
                quarterTurns: 1,
                child: Text('Words', style: TextStyle(fontSize: 20)),
              ),
            ),
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
    final contentNotifier = ref.read(selectedContentStateProvider.state).state!;

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

                  return WordSectionWidget(categoryRow.key, categoryRow.value);
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
            Text(contentNotifier.wordCount),
            const Text(' '),
            Text(
              contentNotifier.awarnessPercent.toStringAsFixed(1) + ' %',
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.toggle_off),
              onPressed: () {
                ref.read(StudyPage.showContentWordsProvider.state).state =
                    !ref.read(StudyPage.showContentWordsProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
