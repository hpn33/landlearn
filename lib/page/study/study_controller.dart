import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/analyze_content.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/service/models/word_notifier.dart';

final studyVMProvider = Provider((ref) => StudyController());

class StudyController {
  final contentStack = <ContentNotifier>[];
  final selectionStack = <ValueNotifier<List<WordNotifier>>>[];

  ContentNotifier? selectedContent;

  void init(ContentNotifier contentNotifier, WordNotifier? selectedWord) {
    if (selectionStack.isNotEmpty) {
      _disableSelections();
    }

    selectedContent = contentNotifier;
    _pushStack();

    // add & enable selected word
    if (selectedWord != null) {
      addSelectedWord(selectedWord);

      _enableSelections();
    }
  }

  void dispose() {
    _disableSelections();

    _popStack();

    if (contentStack.isNotEmpty) {
      selectedContent = contentStack.last;

      _enableSelections();
    } else {
      selectedContent = null;
    }
  }

  //-------- words --------

  void _enableSelections() {
    for (var word in selectedWords.value) {
      word.setSelection(true);
    }
  }

  void _disableSelections() {
    for (var word in selectedWords.value) {
      word.setSelection(false);
    }
  }

  //--------- selected word ----------

  ValueNotifier<List<WordNotifier>> get selectedWords => selectionStack.last;

  void toggleWordSelection(WordNotifier wordNotifier) {
    if (wordNotifier.selected) {
      removeSelectedWrod(wordNotifier);
    } else {
      addSelectedWord(wordNotifier);
    }
  }

  void addSelectedWord(WordNotifier wordNotifier) {
    wordNotifier.setSelection(true);

    selectedWords.value = [...selectedWords.value, wordNotifier];
  }

  void removeSelectedWrod(WordNotifier wordNotifier) {
    wordNotifier.setSelection(false);

    selectedWords.value = [...selectedWords.value..remove(wordNotifier)];
  }

  //---------- Stack ----------

  void _pushStack() {
    contentStack.add(selectedContent!);
    selectionStack.add(ValueNotifier([]));
  }

  void _popStack() {
    contentStack.removeLast();
    selectionStack.removeLast();
  }
}

final textControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  final contentNotifier = ref.watch(studyVMProvider).selectedContent;

  return TextEditingController(
    text: contentNotifier == null ? 'something Wrong' : contentNotifier.content,
  );
});

/// logic

/// extract work from content text
Future<void> analyze(WidgetRef ref) async {
  final contentNotifier = ref.read(studyVMProvider).selectedContent!;
  final wordHub = ref.read(wordHubProvider);
  final db = ref.read(dbProvider);

  analyzeContent(db, contentNotifier, wordHub);
}
