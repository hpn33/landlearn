import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/widget/word_section_widget.dart';

import '../study_controller.dart';

class ContentWordWidget extends HookConsumerWidget {
  const ContentWordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.read(selectedContentStateProvider.state).state!;

    useListenable(contentNotifier);

    final wordCategoris = contentNotifier.wordCategoris;

    return Center(
      child: SizedBox(
        width: 750,
        child: Column(
          children: [
            status(contentNotifier),
            Expanded(
              child: ListView.builder(
                itemCount: wordCategoris.length,
                itemBuilder: (context, index) {
                  final categoryRow = wordCategoris.entries.elementAt(index);

                  return WordSectionWidget(categoryRow.key, categoryRow.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget status(ContentNotifier contentNotifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(contentNotifier.wordCount),
            const Text(' '),
            Text(
              contentNotifier.awarnessPercent.toStringAsFixed(1) + ' %',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
