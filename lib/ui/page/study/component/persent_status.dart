import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';

import '../logic/study_controller.dart';

class PercentStatusWidget extends ConsumerWidget {
  const PercentStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.read(studyVMProvider).selectedContent;

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
