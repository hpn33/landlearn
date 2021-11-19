import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/component/content_text.dart';
import 'package:landlearn/page/study/component/content_words.dart';

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

class StudyPage extends HookWidget {
  static final editModeProvider = StateProvider((ref) => false);

  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const AppbarWidget(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: ContentTextWidget(),
                ),
                Expanded(
                  child: ContentWordWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
