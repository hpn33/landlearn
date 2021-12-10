import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/open_browser.dart';
import 'package:landlearn/widget/my_overlay_panel_widget.dart';
import 'package:landlearn/widget/word_panel_open_widget.dart';
import 'package:translator/translator.dart';

import '../study_controller.dart';

class KnowlageView extends HookConsumerWidget {
  const KnowlageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.watch(selectedContentProvider)!;

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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: ListView.builder(
        padding: const EdgeInsets.only(right: 8),
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

              // const textStyle = TextStyle(
              //   fontSize: 20,
              //   fontWeight: FontWeight.w500,
              // );

              // final size = _textSize(word, textStyle);

              // final child = Stack(
              //   children: [
              //     if (!isNormal)
              //       Positioned(
              //         // right: 0,
              //         bottom: 3,
              //         child: Container(
              //           height: 8,
              //           width: size.width,
              //           // padding: const EdgeInsets.all(0.1),
              //           color: wordNotifier.know ? Colors.green[200] : null,
              //         ),
              //       ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 1),
              //       child: Container(
              //         // padding: const EdgeInsets.all(0.1),
              //         // decoration: isNormal
              //         //     ? null
              //         //     : BoxDecoration(
              //         //         color:
              //         //             wordNotifier.know ? Colors.green[100] : null,
              //         //         borderRadius: BorderRadius.circular(5),
              //         //       ),
              //         child: Text(
              //           word,
              //           style: const TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // );

              final child = Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Container(
                  padding: const EdgeInsets.all(0.1),
                  decoration: isNormal
                      ? null
                      : BoxDecoration(
                          color: wordNotifier.selected
                              ? Colors.blue[200]
                              : wordNotifier.know
                                  ? Colors.grey[300]
                                  : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                  // child: CompositedTransformTarget(
                  //   link: myOverLayPanel.layerLink,
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // ),
              );

              if (isNormal) {
                return child;
              }

              return WordPanelOpenWidget(
                wordNotifier: wordNotifier,
                child: MyOverlayPanelWidget(
                  wordNotifier: wordNotifier,
                  child: InkWell(
                    onTap: () {
                      wordNotifier.toggleKnowToDB(ref);
                    },
                    onLongPress: () async {
                      openGoogleTranslateInBrowser(wordNotifier.word);
                    },
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Here it is!
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

final translate = FutureProvider.family<Translation, WordNotifier>(
  (ref, wordNotifier) async =>
      wordNotifier.word.translate(from: 'en', to: 'fa'),
);

final repoTranslate = FutureProvider.family<String, WordNotifier>(
  (ref, wordNotifier) async {
    if (wordNotifier.onlineTranslation != null) {
      return Future.value(wordNotifier.value.onlineTranslation!);
    }

    final translation = await ref.watch(translate(wordNotifier).future);

    final db = ref.read(dbProvider);
    await db.wordDao.updateOnlineTranslation(
      wordNotifier.value,
      translation.toString(),
    );
    wordNotifier.updateOnlineTranslation(translation.toString());

    return translation.toString();
  },
);
