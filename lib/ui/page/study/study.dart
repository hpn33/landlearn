import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/util/screen_size.dart';
import 'package:landlearn/ui/page/study/study_desktop.dart';

import 'component/key_bind.dart';
import 'logic/view_mode.dart';
import 'logic/study_controller.dart';
import 'study_mobile.dart';

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
        child: getChild(context),
      ),
    );
  }

  Widget getChild(BuildContext context) {
    if (screenSize(context).isCompactScreen) {
      return const StudyMobilePage();
    }

    return const StudyDesktopPage();
  }
}
