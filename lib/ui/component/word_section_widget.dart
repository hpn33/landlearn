import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/word_category_notifier.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/logic/util/open_browser.dart';
import 'package:landlearn/logic/util/platform_util.dart';

import 'my_overlay_panel_widget.dart';
import 'word_panel.dart';
import 'word_panel_open_widget.dart';

class WordSectionWidget extends StatelessWidget {
  final String alphaChar;
  final WordCategoryNotifier wordCategoryNotifier;

  const WordSectionWidget({
    Key? key,
    required this.alphaChar,
    required this.wordCategoryNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Row(
              children: [
                Text(
                  alphaChar,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  wordCategoryNotifier.knowCount.toString(),
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.green,
                    decorationThickness: 4,
                  ),
                ),
                const Text('/'),
                Text(wordCategoryNotifier.length.toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: HookBuilder(builder: (context) {
              useListenable(wordCategoryNotifier);

              return Wrap(
                children: [
                  for (final word in wordCategoryNotifier.words) wordItem(word),
                ],
              );
            }),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget wordItem(WordNotifier wordNotifier) {
    return HookConsumer(builder: (context, ref, child) {
      useListenable(wordNotifier);

      return WordPanelOpenWidget(
        wordNotifier: wordNotifier,
        child: MyOverlayPanelWidget(
          wordNotifier: wordNotifier,
          child: Card(
            elevation: 0,
            color: wordNotifier.know ? Colors.green[100] : Colors.grey[200],
            child: InkWell(
              onTap: () {
                wordNotifier.toggleKnowToDB(ref);
              },
              onLongPress: () {
                if (isMobile()) {
                  ref.read(selectedWordNotifierProvider.state).state =
                      wordNotifier;

                  showDialog(
                    context: context,
                    builder: (context) => const WordPanel(),
                  );
                } else {
                  openGoogleTranslateInBrowser(wordNotifier.word);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(wordNotifier.word),
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            wordNotifier.know ? Colors.white : Colors.grey[400],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(
                          wordNotifier.totalCount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                wordNotifier.know ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
