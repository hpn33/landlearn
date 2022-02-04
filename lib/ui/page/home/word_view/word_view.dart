import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/word_category_notifier.dart';
import 'package:landlearn/logic/model/word_hub.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/ui/component/search_box.dart';
import 'package:landlearn/ui/component/word_section_widget.dart';
import 'package:landlearn/ui/page/home/word_view/word_order_button.dart';
import 'package:landlearn/ui/page/home/word_view/word_short_status.dart';

import '../../../float/add_word_dialog.dart';

class WordView extends ConsumerWidget {
  const WordView({Key? key}) : super(key: key);

  static final searchedWordProvider =
      StateProvider<Map<String, WordCategoryNotifier>>((ref) {
    final wordCategory = ref.watch(wordHubProvider).wordCategories;
    final searchInput = ref.watch(SearchBox.searchProvider('word'));

    if (searchInput.isEmpty) {
      return wordCategory;
    }

    final searchResult = <String, WordCategoryNotifier>{};

    for (final row in wordCategory.entries) {
      final words = row.value.words;
      final filteredWords = words
          .where((word) => word.word.toLowerCase().contains(searchInput))
          .toList();

      if (filteredWords.isNotEmpty) {
        searchResult[row.key] = WordCategoryNotifier()..addAll(filteredWords);
      }
    }

    return searchResult;
  });

  static final orderProvider = StateProvider((ref) => 'Norm');
  static final wordsProvider =
      StateProvider<Map<String, WordCategoryNotifier>>((ref) {
    final searchedWords = ref.watch(searchedWordProvider);
    final order = ref.watch(orderProvider);

    if (order == 'Last') {
      for (var e in searchedWords.values) {
        e.words.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      }

      return searchedWords;
    }

    if (order == 'Most') {
      for (var e in searchedWords.values) {
        e.words.sort((a, b) => b.totalCount.compareTo(a.totalCount));
      }

      return searchedWords;
    }

    if (order == 'Norm') {
      for (var e in searchedWords.values) {
        e.words.sort((a, b) => a.word.compareTo(b.word));
      }
    }

    return searchedWords;
  });

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        const WordShortStatus(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: Column(
              children: [
                _toolBar(context),
                const SearchBox(stateName: 'word'),
                Expanded(
                  child: listViewWidget(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _toolBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          const Text(
            'Words',
            style: TextStyle(fontSize: 16),
          ),
          // statusOfWord(),
          const Spacer(),

          //
          const WordOrderButton(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => addWordDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listViewWidget() {
    return HookConsumer(builder: (context, ref, child) {
      final wordCategories = ref
          .watch(wordsProvider)
          .entries
          .where((element) => element.value.words.isNotEmpty);

      final scrollController = useScrollController();

      if (wordCategories.isEmpty) {
        return const Center(
          child: Text(
            'Empty',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          // shrinkWrap: true,
          controller: scrollController,
          itemCount: wordCategories.length,
          itemBuilder: (context, index) {
            final alphaChar = wordCategories.elementAt(index).key;
            final category = wordCategories.elementAt(index).value;

            return WordSectionWidget(
              key: ValueKey(alphaChar),
              alphaChar: alphaChar,
              wordCategoryNotifier: category,
            );
          },
        ),
      );
    });
  }
}
