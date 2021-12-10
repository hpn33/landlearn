import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/open_browser.dart';
import 'package:landlearn/widget/my_overlay_panel_widget.dart';
import 'package:landlearn/widget/word_panel_open_widget.dart';

class ReadView extends HookConsumerWidget {
  const ReadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.watch(studyVMProvider).selectedContent!;

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

              // useOnAppLifecycleStateChange((p, c) {
              //   print(p);
              //   print(c);
              // });

              // print(useAppLifecycleState());

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

              Widget text = Text(
                word,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              );

              if (isNormal) {
                text = Stack(
                  children: [
                    Positioned(
                      bottom: 1,
                      child: Container(
                        width: _textSize(
                          word,
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ).width,
                        height: 3,
                        color: wordNotifier.selected ? Colors.blue[400] : null,
                      ),
                    ),
                    text,
                  ],
                );
              }

              final child = Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Container(
                  padding: const EdgeInsets.all(0.1),
                  decoration: isNormal
                      ? null
                      : viewMode == ViewMode.know
                          ? BoxDecoration(
                              color: wordNotifier.selected
                                  ? Colors.blue[200]
                                  : wordNotifier.know
                                      ? Colors.grey[300]
                                      : null,
                              borderRadius: BorderRadius.circular(5),
                            )
                          : BoxDecoration(
                              color: wordNotifier.selected
                                  ? Colors.blue[200]
                                  : wordNotifier.know
                                      ? null
                                      : Colors.yellow[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                  // child: CompositedTransformTarget(
                  //   link: myOverLayPanel.layerLink,
                  child: text,
                ),
                // ),
              );

              if (isNormal) {
                return WordPanelOpenWidget(
                  wordNotifier: wordNotifier,
                  child: child,
                );
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
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

    return textPainter.size;
  }
}
