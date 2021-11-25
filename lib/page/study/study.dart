import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/component/content_text.dart';
import 'package:landlearn/page/study/component/content_words.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';

import 'component/appbar.dart';

/// TODO:  goal: improve data flow in study page
/// refactor
///
/// first load all needed data - content and words
///
/// better refresh
/// faster load
///
/// when change content and remove word
/// the word not remove from word of content (wordmap maybe)
///
/// get all word and check with saved word
/// any that not was there add to add list
/// and add to database
///
/// study managment
/// manager content text and word of content
/// on edit
/// update word

class StudyPage extends HookConsumerWidget {
  static final viewModeProvider =
      StateProvider.autoDispose((ref) => ViewMode.normal);
  static final showContentTextProvider =
      StateProvider.autoDispose((ref) => true);
  static final showContentWordsProvider =
      StateProvider.autoDispose((ref) => false);

  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Material(
      child: Column(
        children: [
          const AppbarWidget(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ref.watch(showContentTextProvider))
                  const Expanded(
                    child: ContentTextWidget(),
                  ),
                const ContentWordToggleWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
