import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/ui/component/styled_percent_widget.dart';
import 'package:landlearn/ui/page/home/component/overlay_checkbox.dart';

import 'component/content_text.dart';
import 'component/content_words.dart';
import 'component/key_bind.dart';
import 'component/persent_status.dart';
import 'component/toggle_view_mode.dart';
import 'logic/view_mode.dart';
import 'logic/study_controller.dart';

class StudyPage extends HookConsumerWidget {
  static final viewModeProvider = StateProvider((ref) => ViewMode.normal);
  static final showContentWordsProvider = StateProvider((ref) => false);
  static final showSubtitleProvider = StateProvider((ref) => false);
  static final showOverlayProvider = StateProvider((ref) => true);

  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return WillPopScope(
      onWillPop: () {
        ref.read(studyVMProvider).dispose();

        return Future.value(true);
      },
      child: StudyKeyBinds(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 950
                        ? MediaQuery.of(context).size.width > 1140
                            ? 1140
                            : MediaQuery.of(context).size.width * 0.8
                        : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _bar(),
                        const Expanded(
                          child: ContentTextWidget(),
                        ),
                        const ContentWordToggleWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar() => HookConsumer(
        builder: (context, ref, child) {
          final contentNotifier = ref.read(studyVMProvider).selectedContent;
          final showSubtitle = ref.watch(showSubtitleProvider);

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
                          ref.read(showSubtitleProvider.state).state = a!;
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
        },
      );

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
                    awarnessPercent: contentNotifier.awarnessPercentOfAllWord),
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
