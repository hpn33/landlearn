import 'dart:ui';

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

    // load data
    final paragraphs = useState<List<Map<String, WordNotifier?>>>([]);

    useEffect(
      () {
        paragraphs.value = [
          for (final paragraph in contentNotifier.content.split('\n'))
            <String, WordNotifier?>{
              for (final word in paragraph.split(' '))
                word: contentNotifier.getWordNotifier(word),
            },
        ];
      },
      [contentNotifier.content],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: paragraphs.value.length,
        itemBuilder: (context, index) {
          final paragraph = paragraphs.value[index];

          return RichText(
            text: paragraphSection(paragraph, contentNotifier),
          );
        },
      ),
    );
  }

  TextSpan paragraphSection(
    Map<String, WordNotifier?> paragraph,
    ContentNotifier contentNotifier,
  ) {
    return TextSpan(
      children: [
        for (final wordRow in paragraph.entries) ...[
          wordSection(contentNotifier, wordRow.key, wordRow.value),
          const TextSpan(
            text: ' ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
      ],
    );
  }

  WidgetSpan wordSection(
    ContentNotifier contentNotifier,
    String word,
    WordNotifier? wordNotifier,
  ) {
    return WidgetSpan(
      child: HookBuilder(
        key: Key(word.isEmpty ? 'empty' : word),
        builder: (context) {
          useListenable(wordNotifier ?? ChangeNotifier());

          if (wordNotifier == null) {
            if (word.isEmpty) {
              return const SizedBox(width: 0);
            }

            if (word.runes.first == 13) {
              return Text(word);
            }

            // if (word == ' ') {
            //   return Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 1),
            //     child: Container(
            //       padding: const EdgeInsets.all(0.1),
            //       child: const Text(
            //         ' ',
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   );
            // }

            return Text('($word)');
          }

          return HookConsumer(
            key: Key(contentNotifier.id.toString()),
            builder: (context, ref, child) {
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
