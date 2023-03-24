import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/ui/page/study/study.dart';

class OverlayCheckBox extends ConsumerWidget {
  const OverlayCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final showSubtitle = ref.watch(StudyPage.showSubtitleProvider);

    if (showSubtitle) {
      return const SizedBox();
    }

    return _checkBox();
  }

  Widget _checkBox() {
    return Consumer(builder: (context, ref, child) {
      final showOverlay = ref.watch(StudyPage.showOverlayProvider.notifier);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          children: [
            const Text('Overlay'),
            Checkbox(
              value: showOverlay.state,
              onChanged: (a) => showOverlay.state = a!,
            ),
          ],
        ),
      );
    });
  }
}
