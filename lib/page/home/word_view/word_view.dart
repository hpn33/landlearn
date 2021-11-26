import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/widget/styled_percent_widget.dart';
import 'package:landlearn/widget/word_section_widget.dart';

import '../../dialog/add_word_dialog.dart';

class WordView extends StatelessWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        toolBar(context),
        Expanded(
          child: listViewWidget(),
        ),
      ],
    );
  }

  Widget toolBar(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            statusOfWord(),
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
      ),
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
            Text('$totalCount'),
            // Text('/$unknowCount'),
            // const SizedBox(width: 8),
            Text('/$knowCount'),
            const Text(' '),
            StyledPercent(
              awarnessPercent: (knowCount / totalCount * 100),
              fractionDigits: 2,
            ),
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
      child: Row(
        children: [
          Expanded(
            child: HookConsumer(builder: (context, ref, child) {
              final wordCategories =
                  ref.watch(wordHubProvider).wordCategories.entries;

              return ListView.builder(
                itemCount: wordCategories.length,
                itemBuilder: (context, index) {
                  final alphaChar = wordCategories.elementAt(index).key;
                  final category = wordCategories.elementAt(index).value;

                  return WordSectionWidget(alphaChar, category);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
