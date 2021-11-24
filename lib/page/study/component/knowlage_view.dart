import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/util/util.dart';
import 'package:landlearn/service/models/word_notifier.dart';

import '../study_controller.dart';

class KnowlageView extends HookConsumerWidget {
  const KnowlageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final textController = ref.watch(textControllerProvider);
    final contentNotifier = ref.read(selectedContentStateProvider)!;

    return RichText(
      text: TextSpan(
        children: [
          for (final paragh in textController.text.split('\n')) ...[
            paragraphSection(paragh, contentNotifier),
            const TextSpan(text: '\n'),
          ],
        ],
      ),
    );
  }

  TextSpan paragraphSection(
    String paragh,
    ContentNotifier contentNotifier,
  ) {
    return TextSpan(
      children: [
        for (final word in paragh.split(regex))
          wordSection(contentNotifier, word),
      ],
    );
  }

  WidgetSpan wordSection(ContentNotifier contentNotifier, String word) {
    return WidgetSpan(
      child: HookConsumer(
        builder: (context, ref, child) {
          final wordNotifier = contentNotifier.getWordNotifier(word);

          useListenable(wordNotifier ?? ChangeNotifier());

          if (wordNotifier == null) {
            return Text('($word)');
          }

          return InkWell(
            onTap: () {
              wordNotifier.toggleKnowToDB(ref);
            },
            child: Text(
              word + ' ',
              style: TextStyle(
                color: wordNotifier.know ? Colors.green : Colors.black,
                // decoration: wordNotifier.know ? TextDecoration.underline : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
