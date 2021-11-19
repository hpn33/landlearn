import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/util.dart';

import '../study.dart';
import '../study_controller.dart';

class ContentTextWidget extends HookConsumerWidget {
  const ContentTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewMode = ref.watch(StudyPage.viewModeProvider);
    final contentNotifier = ref.read(selectedContentStateProvider)!;
    final textController = ref.watch(textControllerProvider);

    useListenable(contentNotifier);

    return SingleChildScrollView(
        child: getView(viewMode, contentNotifier, textController));
  }

  Widget getView(
    ViewMode viewMode,
    ContentNotifier contentNotifier,
    TextEditingController textController,
  ) {
    if (viewMode == ViewMode.edit) {
      return TextField(
        controller: textController,
        minLines: 20,
        maxLines: 1000,
      );
    }

    if (viewMode == ViewMode.clearKnowladge) {
      return const KnowlageView();
    }

    return Text(
      contentNotifier.content,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

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
