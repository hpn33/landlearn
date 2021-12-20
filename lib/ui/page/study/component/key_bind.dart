import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/ui/page/study/logic/view_mode.dart';

import '../study.dart';

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
