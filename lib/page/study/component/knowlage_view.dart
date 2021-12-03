import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

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

              final overlayEntry = useState<OverlayEntry?>(null);
              final layerLink = useState(LayerLink());

              // useEffect(
              //   () {
              //     WidgetsBinding.instance!.addPostFrameCallback(
              //       (_) => showOverlay(context, overlayEntry, layerLink),
              //     );

              //     // return () => hideOverlay(overlayEntry);
              //   },
              //   [],
              // );

              // const textStyle = TextStyle(
              //   fontSize: 20,
              //   fontWeight: FontWeight.w500,
              // );

              // final size = _textSize(word, textStyle);

              // final child = Stack(
              //   children: [
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
              //     if (!isNormal)
              //       Positioned(
              //         // right: 0,
              //         bottom: 0,
              //         child: Container(
              //           height: 2,
              //           width: size.width,
              //           // padding: const EdgeInsets.all(0.1),
              //           color: wordNotifier.know ? Colors.green[300] : null,
              //         ),
              //       ),
              //   ],
              // );

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
                  child: CompositedTransformTarget(
                    link: layerLink.value,
                    child: Text(
                      word,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );

              if (isNormal) {
                return child;
              }

              return MouseRegion(
                onEnter: (pointerHoverEvent) {
                  showOverlay(
                    context,
                    overlayEntry,
                    layerLink,
                    wordNotifier,
                  );
                },
                onExit: (pointerExitEvent) {
                  hideOverlay(overlayEntry);
                },
                child: InkWell(
                  onTap: () {
                    wordNotifier.toggleKnowToDB(ref);
                  },
                  onLongPress: () async {
                    final url =
                        "https://translate.google.com/?sl=en&tl=fa&text=$word&op=translate";
                    if (!await launch(url)) {
                      throw 'Could not launch $url';
                    }
                  },
                  child: child,
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

  void showOverlay(
      BuildContext context,
      ValueNotifier<OverlayEntry?> overlayEntry,
      ValueNotifier<LayerLink> layerLink,
      WordNotifier word) {
    if (overlayEntry.value != null) {
      return;
    }

    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    overlayEntry.value = OverlayEntry(
      builder: (context) => Positioned(
        width: 150,
        child: CompositedTransformFollower(
          link: layerLink.value,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: buildOverlay(context, overlayEntry, word),
        ),
      ),
    );

    overlay.insert(overlayEntry.value!);
  }

  void hideOverlay(ValueNotifier<OverlayEntry?> overlayEntry) {
    if (overlayEntry.value != null) {
      overlayEntry.value!.remove();
      overlayEntry.value = null;
    }
  }

  static final translate = FutureProvider.family<Translation, WordNotifier>(
    (ref, wordNotifier) async =>
        wordNotifier.word.translate(from: 'en', to: 'fa'),
  );

  static final repoTranslate = FutureProvider.family<String, WordNotifier>(
    (ref, wordNotifier) async {
      if (wordNotifier.value.onlineTranslation != null) {
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

  Widget buildOverlay(BuildContext context, overlayEntry, WordNotifier word) {
    return HookConsumer(builder: (context, ref, child) {
      return Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(4),
          width: 50,
          height: 50,
          child: Text(
            ref.watch(repoTranslate(word)).when(
                  data: (d) => d,
                  error: (e, s) => 'err',
                  loading: () => '...',
                ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }
}
