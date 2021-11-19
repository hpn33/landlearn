import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/util.dart';

import '../study.dart';
import '../study_controller.dart';

class ContentTextWidget extends HookConsumerWidget {
  const ContentTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final textController = ref.watch(textControllerProvider);
    final editMode = ref.watch(StudyPage.editModeProvider);
    final contentNotifier = ref.read(selectedContentStateProvider)!;

    useListenable(contentNotifier);

    return SingleChildScrollView(
      child: editMode
          ? TextField(
              controller: textController,
              minLines: 20,
              maxLines: 1000,
            )
          // : Text(textController.text),
          : RichText(
              text: TextSpan(
                children: [
                  for (final paragh in textController.text.split('\n')) ...[
                    paragraphSection(paragh, contentNotifier),
                    const TextSpan(text: '\n'),
                  ],
                ],
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
                decoration: wordNotifier.know ? TextDecoration.underline : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
