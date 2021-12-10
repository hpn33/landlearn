import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_notifier.dart';

import '../study_controller.dart';
import 'toggle_view_mode.dart';

class AppbarStudy extends HookConsumerWidget {
  const AppbarStudy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final studyVM = ref.read(studyVMProvider);
    final contentNotifier = studyVM.selectedContent;

    useListenable(contentNotifier ?? ChangeNotifier());

    if (contentNotifier == null) {
      return Container();
    }

    return Material(
      elevation: 6,
      child: Row(
        children: [
          BackButton(onPressed: () {
            studyVM.dispose();
            Navigator.pop(context);
          }),
          Text('count ${contentNotifier.allWordCount}'),
          const SizedBox(width: 10),
          Text('uniqe ${contentNotifier.wordCount}'),
          const SizedBox(width: 10),
          const ToggleViewModeButton(),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: percentStatus(contentNotifier),
          ),
        ],
      ),
    );
  }

  Widget percentStatus(ContentNotifier contentNotifier) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: contentNotifier.awarnessPercentOfAllWord.toInt(),
              child: Container(
                height: 3,
                color: Colors.green[300],
              ),
            ),
            Expanded(
              flex: 100 - contentNotifier.awarnessPercentOfAllWord.toInt(),
              child: Container(
                height: 3,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Row(
          children: [
            Expanded(
              flex: contentNotifier.awarnessPercent.toInt(),
              child: Container(
                height: 3,
                color: Colors.blue[300],
              ),
            ),
            Expanded(
              flex: 100 - contentNotifier.awarnessPercent.toInt(),
              child: Container(
                height: 3,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
