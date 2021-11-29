import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';

import '../study_controller.dart';

class KnowlageView extends HookConsumerWidget {
  const KnowlageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.watch(selectedContentStateProvider)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
        child: RichText(
          text: TextSpan(
            children: [
              for (final paragh in contentNotifier.content.split('\n')) ...[
                paragraphSection(paragh, contentNotifier),
                const TextSpan(text: '\n'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  TextSpan paragraphSection(
    String paragh,
    ContentNotifier contentNotifier,
  ) {
    return TextSpan(
      children: [
        for (final word in paragh.split(' ')) ...[
          wordSection(contentNotifier, word),
          const WidgetSpan(
            child: Text(
              ' ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    );
  }

  // TODO: store result to faster refresh
  WidgetSpan wordSection(ContentNotifier contentNotifier, String word) {
    return WidgetSpan(
      child: HookConsumer(
        key: Key(word),
        builder: (context, ref, child) {
          final wordNotifier = contentNotifier.getWordNotifier(word);

          useListenable(wordNotifier ?? ChangeNotifier());

          if (wordNotifier == null) {
            if (word.runes.first == 13) {
              return Text(word);
            }

            return Text('($word)');
          }

          return HookBuilder(
            key: Key(contentNotifier.id.toString()),
            builder: (context) {
              final viewMode = ref.watch(StudyPage.viewModeProvider);
              final isNormal = viewMode == ViewMode.normal;

              final child = Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Container(
                  padding: const EdgeInsets.all(0.1),
                  decoration: isNormal
                      ? null
                      : BoxDecoration(
                          color: wordNotifier.know ? Colors.green[100] : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );

              if (isNormal) {
                return child;
              }

              return InkWell(
                onTap: () {
                  wordNotifier.toggleKnowToDB(ref);
                },
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
