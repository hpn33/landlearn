import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/ui/component/styled_percent_widget.dart';
import 'package:landlearn/ui/page/home/component/overlay_checkbox.dart';
import 'package:landlearn/ui/page/study/logic/study_controller.dart';
import 'package:landlearn/ui/page/study/study.dart';

import 'persent_status.dart';
import 'toggle_view_mode.dart';

class SideBar extends HookConsumerWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.read(studyVMProvider).selectedContent;
    final showSubtitle = ref.watch(StudyPage.showSubtitleProvider);

    return SizedBox(
      width: 55,
      child: Column(
        children: [
          const BackButton(),
          const ToggleViewModeButton2(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                const Text('Subtitle'),
                Checkbox(
                  value: showSubtitle,
                  onChanged: (a) {
                    ref.read(StudyPage.showSubtitleProvider.state).state = a!;
                  },
                ),
              ],
            ),
          ),
          const OverlayCheckBox(),
          const Spacer(),
          _awarnessStatus(contentNotifier),
        ],
      ),
    );
  }

  Widget _awarnessStatus(ContentNotifier contentNotifier) => HookBuilder(
        builder: (context) {
          useListenable(contentNotifier);

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 12,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Text('${contentNotifier.allWordCount}'),
                StyledPercent(
                  awarnessPercent: contentNotifier.awarnessPercentOfAllWord,
                ),
                const SizedBox(height: 8),
                const PercentStatusWidget(),
                const SizedBox(height: 8),
                Text('${contentNotifier.wordCount}'),
                StyledPercent(
                  awarnessPercent: contentNotifier.awarnessPercent,
                  color: Colors.blue[100],
                ),
              ],
            ),
          );
        },
      );
}
