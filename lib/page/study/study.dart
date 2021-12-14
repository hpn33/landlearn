import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/component/content_text.dart';
import 'package:landlearn/page/study/component/content_words.dart';
import 'package:landlearn/page/study/component/persent_status.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/models/content_notifier.dart';

import 'component/toggle_view_mode.dart';

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
              // const AppbarStudy(),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 1100
                        ? MediaQuery.of(context).size.width > 1500
                            ? 1500
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
          final contentNotifier = ref.read(studyVMProvider).selectedContent!;
          final showSubtitle = ref.watch(showSubtitleProvider);

          return SizedBox(
            // color: Colors.blue[200],
            width: 55,
            child: Column(
              children: [
                const BackButton(),
                const ToggleViewModeButton2(),
                // CheckboxListTile(
                //   title: Text('title'),
                //   value: false,
                //   onChanged: (a) {},
                // ),

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

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    children: [
                      const Text('Overlay'),
                      Checkbox(
                        value: ref.watch(showOverlayProvider),
                        onChanged: showSubtitle
                            ? null
                            : (a) {
                                ref.read(showOverlayProvider.state).state = a!;
                              },
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(
                    // color: Colors.grey[300],
                    // width: 1,
                    // ),
                  ),
                  child: Column(
                    children: [
                      const PercentStatusWidget(),
                      const SizedBox(height: 16),
                      Text(
                        '${contentNotifier.allWordCount}\nCount',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class StudyKeyBinds extends ConsumerWidget {
  final Widget child;

  const StudyKeyBinds({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.tab): ToggleViewModeIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit1): ViewModeNormalIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit2): ViewModeKnowIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit3): ViewModeUnknowIntent(),
      },
      child: Actions(
        actions: {
          ToggleViewModeIntent: CallbackAction(onInvoke: (intent) {
            final mode = ref.read(StudyPage.viewModeProvider.state);

            if (mode.state == ViewMode.normal) {
              mode.state = ViewMode.know;
            } else if (mode.state == ViewMode.know) {
              mode.state = ViewMode.unknow;
            } else if (mode.state == ViewMode.unknow) {
              mode.state = ViewMode.normal;
            }
          }),
          ViewModeNormalIntent: CallbackAction(onInvoke: (intent) {
            ref.read(StudyPage.viewModeProvider.state).state = ViewMode.normal;
          }),
          ViewModeKnowIntent: CallbackAction(onInvoke: (intent) {
            ref.read(StudyPage.viewModeProvider.state).state = ViewMode.know;
          }),
          ViewModeUnknowIntent: CallbackAction(onInvoke: (intent) {
            ref.read(StudyPage.viewModeProvider.state).state = ViewMode.unknow;
          }),
        },
        child: child,
      ),
    );
  }
}

class ToggleViewModeIntent extends Intent {}

class ViewModeNormalIntent extends Intent {}

class ViewModeKnowIntent extends Intent {}

class ViewModeUnknowIntent extends Intent {}
