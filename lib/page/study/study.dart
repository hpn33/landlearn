import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/logic/analyze_content.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/util/util.dart';
import 'package:landlearn/widget/word_section_widget.dart';

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
          topBar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: contentView(),
                ),
                Expanded(
                  child: wordOfContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentView() {
    return HookConsumer(builder: (context, ref, child) {
      final textController = ref.watch(textControllerProvider);
      final editMode = ref.watch(editModeProvider);
      final contentNotifier = ref.read(selectedContentStateProvider)!;

      useListenable(contentNotifier);

      return SingleChildScrollView(
        child: editMode
            ? TextField(
                controller: textController,
                minLines: 20,
                maxLines: 1000,
              )
            // : Text(textController.text),
            : RichText(
                text: TextSpan(
                  children: [
                    for (final paragh in textController.text.split('\n')) ...[
                      TextSpan(
                        children: [
                          for (final word in paragh.split(regex))
                            WidgetSpan(
                              child: HookBuilder(
                                builder: (context) {
                                  final wordNotifier =
                                      contentNotifier.getNotifier(word);

                                  useListenable(
                                      wordNotifier ?? ChangeNotifier());

                                  if (wordNotifier == null) {
                                    return Text('($word)');
                                  }

                                  return InkWell(
                                    onTap: () {
                                      wordNotifier.toggleKnowToDB(ref);
                                    },
                                    child: Text(
                                      word + ' ',
                                      style: TextStyle(
                                        color: wordNotifier.know
                                            ? Colors.green
                                            : Colors.black,
                                        decoration: wordNotifier.know
                                            ? TextDecoration.underline
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      const TextSpan(text: '\n'),
                    ],
                  ],
                ),
              ),
      );
    });
  }

  Widget wordOfContent() {
    return HookConsumer(builder: (context, ref, child) {
      final contentNotifier =
          ref.read(selectedContentStateProvider.state).state!;
      useListenable(contentNotifier);

      final wordCategoris = contentNotifier.wordCategoris;

      return SingleChildScrollView(
        child: Column(
          children: [
            for (final categoryRow in wordCategoris.entries)
              WordSectionWidget(categoryRow.key, categoryRow.value),
          ],
        ),
      );
    });
  }

  Widget topBar() {
    return HookConsumer(
      builder: (context, ref, child) {
        final editMode = ref.watch(editModeProvider.notifier);
        final contentNotifier = ref.read(selectedContentStateProvider)!;

        useListenable(contentNotifier);

        return Material(
          elevation: 6,
          child: Row(
            children: [
              const BackButton(),
              Text(
                'text word\n${contentNotifier.allWordCount}',
                textAlign: TextAlign.center,
              ),
              Text(
                'word count\n${contentNotifier.wordCount}',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: const Text('analyze'),
                onPressed: () => analyze(ref),
              ),
              ElevatedButton(
                child: Text(editMode.state ? 'done' : 'edit'),
                onPressed: () async {
                  final contentNotifier =
                      ref.read(selectedContentStateProvider)!;

                  final textController = ref.read(textControllerProvider);

                  if (textController.text != contentNotifier.content) {
                    await ref.read(dbProvider).contentDao.updateContent(
                          contentNotifier.value,
                          textController.text,
                        );

                    contentNotifier.updateContent(textController.text);
                  }

                  editMode.state = !editMode.state;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// extract work from content text
  /// remove dub
  ///
  /// check for add or get
  ///
  /// update
  ///
  /// ready to use
  void analyze(WidgetRef ref) async {
    final contentNotifier = ref.read(selectedContentStateProvider)!;
    final wordHub = ref.read(wordHubProvider);
    final db = ref.read(dbProvider);

    analyzeContent(db, contentNotifier, wordHub);
  }
}
