import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_category_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';

class WordSectionWidget extends StatelessWidget {
  final String alphaChar;
  final WordCategoryNotifier wordCategoryNotifier;

  const WordSectionWidget(this.alphaChar, this.wordCategoryNotifier, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 250,
              child: Card(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(alphaChar),
                      Spacer(),
                      Text(wordCategoryNotifier.knowCount.toString()),
                      Text('/'),
                      Text(wordCategoryNotifier.length.toString()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: HookBuilder(builder: (context) {
            useListenable(wordCategoryNotifier);

            // return ListView.builder(
            //   itemCount: wordCategoryNotifier.list.length,
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     final word = wordCategoryNotifier.list[index];

            //     return wordItem(word);
            //   },
            // );

            return Wrap(
              // alignment: WrapAlignment.center,
              children: [
                for (final word in wordCategoryNotifier.list) wordItem(word),
              ],
            );
          }),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget wordItem(WordNotifier wordNotifier) {
    return HookConsumer(builder: (context, ref, child) {
      useListenable(wordNotifier);

      return Card(
        color: wordNotifier.know ? Colors.green[100] : null,
        child: InkWell(
          onTap: () {
            wordNotifier.toggleKnowToDB(ref);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(wordNotifier.word),
                SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: wordNotifier.know ? Colors.white : Colors.grey[400],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      wordNotifier.totalCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: wordNotifier.know ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
