import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/component/content_text.dart';
import 'package:landlearn/page/study/component/content_words.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';
import 'package:landlearn/service/models/word_notifier.dart';

import 'component/appbar.dart';

class StudyPage extends HookConsumerWidget {
  static final viewModeProvider = StateProvider((ref) => ViewMode.normal);
  static final showContentWordsProvider = StateProvider((ref) => false);
  static final selectedWordListProvider =
      StateProvider((ref) => <WordNotifier>[]);

  const StudyPage({Key? key}) : super(key: key);

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
            final mode = ref.read(viewModeProvider.state);

            if (mode.state == ViewMode.normal) {
              mode.state = ViewMode.know;
            } else if (mode.state == ViewMode.know) {
              mode.state = ViewMode.unknow;
            } else if (mode.state == ViewMode.unknow) {
              mode.state = ViewMode.normal;
            }
          }),
          ViewModeNormalIntent: CallbackAction(onInvoke: (intent) {
            ref.read(viewModeProvider.state).state = ViewMode.normal;
          }),
          ViewModeKnowIntent: CallbackAction(onInvoke: (intent) {
            ref.read(viewModeProvider.state).state = ViewMode.know;
          }),
          ViewModeUnknowIntent: CallbackAction(onInvoke: (intent) {
            ref.read(viewModeProvider.state).state = ViewMode.unknow;
          }),
        },
        child: Material(
          child: Column(
            children: [
              const AppbarWidget(),
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
                      children: const [
                        Expanded(
                          child: ContentTextWidget(),
                        ),
                        ContentWordToggleWidget(),
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
}

class ToggleViewModeIntent extends Intent {}

class ViewModeNormalIntent extends Intent {}

class ViewModeKnowIntent extends Intent {}

class ViewModeUnknowIntent extends Intent {}
