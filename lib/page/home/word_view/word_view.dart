import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/widget/styled_percent_widget.dart';
import 'package:landlearn/widget/word_section_widget.dart';

import '../../dialog/add_word_dialog.dart';

class WordView extends StatelessWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: toolBar(context),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          //   child: Column(
          //     children: [
          //       toolBar(context),
          //       statusOfWord(),
          //     ],
          //   ),
          // ),
          Expanded(
            child: listViewWidget(),
          ),
        ],
      ),
    );
  }

  Widget toolBar(BuildContext context) {
    return Row(
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
    );
  }

  Widget statusOfWord() {
    return HookConsumer(
      builder: (context, ref, child) {
        final wordNotifiers = ref.watch(wordHubProvider).wordNotifiers;

        final totalCount = wordNotifiers.length;
        final knowCount = wordNotifiers.where((element) => element.know).length;
        // final unknowCount = totalCount - knowCount;

        return Row(
          children: [
            // const SizedBox(width: 8),
            StyledPercent(
              awarnessPercent: (knowCount / totalCount * 100),
              fractionDigits: 2,
            ),
            const SizedBox(width: 8),

            Text(
              '$knowCount',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 3,
                decorationColor: Colors.green,
              ),
            ),
            Text('/$totalCount'),
            const SizedBox(width: 8),

            // Text('/$unknowCount'),
            // const SizedBox(width: 8),

            // Card(
            //   color: Colors.green[200],
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text('$knowCount ( %' +
            //         (knowCount / totalCount * 100).toStringAsFixed(1) +
            //         ' )'),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget listViewWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: HookConsumer(builder: (context, ref, child) {
        final wordCategories =
            ref.watch(wordHubProvider).wordCategories.entries;

        final scrollController = useScrollController();

        return Scrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ListView.builder(
              itemCount: wordCategories.length,
              itemBuilder: (context, index) {
                final alphaChar = wordCategories.elementAt(index).key;
                final category = wordCategories.elementAt(index).value;

                return WordSectionWidget(alphaChar, category);
              },
            ),
          ),
        );
      }),
    );
  }
}
