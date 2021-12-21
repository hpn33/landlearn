import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'component/content_text.dart';
import 'component/content_words.dart';
import 'component/key_bind.dart';
import 'component/side_bar.dart';
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
                      children: const [
                        SideBar(),
                        Expanded(child: ContentTextWidget()),
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
