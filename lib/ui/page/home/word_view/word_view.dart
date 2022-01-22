import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/word_category_notifier.dart';
import 'package:landlearn/logic/model/word_hub.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/ui/component/word_section_widget.dart';
import 'package:landlearn/ui/page/home/word_view/word_short_status.dart';

import '../../../float/add_word_dialog.dart';

class WordView extends StatelessWidget {
  const WordView({Key? key}) : super(key: key);

  static final searchProvider = StateProvider((ref) => '');

  static final searchedWordProvider =
      StateProvider<Map<String, WordCategoryNotifier>>((ref) {
    final wordCategory = ref.watch(wordHubProvider).wordCategories;
    final searchInput = ref.watch(searchProvider);

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const WordShortStatus(),
          _toolBar(context),
          _order(),
          _search(),
          Expanded(
            child: listViewWidget(),
          ),
        ],
      ),
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

  Widget _order() {
    return HookConsumer(builder: (context, ref, child) {
      final order = ref.watch(orderProvider);

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Row(
            children: [
              const Text('Order'),
              const Spacer(),
              TextButton(
                child: const Text('Norm'),
                onPressed: order == 'Norm'
                    ? null
                    : () => ref.read(orderProvider.state).state = 'Norm',
              ),
              TextButton(
                child: const Text('Most'),
                onPressed: order == 'Most'
                    ? null
                    : () => ref.read(orderProvider.state).state = 'Most',
              ),
              TextButton(
                child: const Text('Last'),
                onPressed: order == 'Last'
                    ? null
                    : () => ref.read(orderProvider.state).state = 'Last',
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _search() => HookConsumer(
        builder: (context, ref, child) {
          final searchController =
              useTextEditingController(text: ref.read(searchProvider));

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      ref.read(searchProvider.state).state = value;
                    },
                  ),
                ),
                HookBuilder(
                  builder: (context) {
                    useListenable(searchController);

                    return Row(
                      children: [
                        if (searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              ref.read(searchProvider.state).state = '';
                            },
                          ),
                        if (searchController.text.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.search),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

  // Widget statusOfWord() {
  //   return HookConsumer(
  //     builder: (context, ref, child) {
  //       final wordNotifiers = ref.watch(wordHubProvider).wordNotifiers;

  //       final totalCount = wordNotifiers.length;
  //       final knowCount = wordNotifiers.where((element) => element.know).length;
  //       // final unknowCount = totalCount - knowCount;

  //       return Row(
  //         children: [
  //           // const SizedBox(width: 8),
  //           StyledPercent(
  //             awarnessPercent: (knowCount / totalCount * 100),
  //             fractionDigits: 2,
  //           ),
  //           const SizedBox(width: 8),

  //           Text(
  //             '$knowCount',
  //             style: const TextStyle(
  //               decoration: TextDecoration.underline,
  //               decorationThickness: 3,
  //               decorationColor: Colors.green,
  //             ),
  //           ),
  //           Text('/$totalCount'),
  //           const SizedBox(width: 8),

  //           // Text('/$unknowCount'),
  //           // const SizedBox(width: 8),

  //           // Card(
  //           //   color: Colors.green[200],
  //           //   child: Padding(
  //           //     padding: const EdgeInsets.all(8.0),
  //           //     child: Text('$knowCount ( %' +
  //           //         (knowCount / totalCount * 100).toStringAsFixed(1) +
  //           //         ' )'),
  //           //   ),
  //           // ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
