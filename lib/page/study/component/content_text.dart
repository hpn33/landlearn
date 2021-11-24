import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';

import '../study.dart';
import '../study_controller.dart';
import 'edit_view.dart';
import 'knowlage_view.dart';

class ContentTextWidget extends HookConsumerWidget {
  const ContentTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewMode = ref.watch(StudyPage.viewModeProvider);

    return Center(
      child: SizedBox(
        width: 750,
        child: getView(viewMode),
      ),
    );
  }

  Widget getView(ViewMode viewMode) {
    if (viewMode == ViewMode.edit) {
      return const EditView();
    }

    if (viewMode == ViewMode.clearKnowladge) {
      return const KnowlageView();
    }

    return textView();
  }

  Widget textView() {
    return HookConsumer(builder: (context, ref, child) {
      final contentNotifier = ref.read(selectedContentStateProvider)!;

      useListenable(contentNotifier);

      return SingleChildScrollView(
        child: Text(
          contentNotifier.content,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    });
  }
}
