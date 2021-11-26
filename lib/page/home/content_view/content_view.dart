import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/content_notifier.dart';

class ContentView extends StatelessWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        toolBar(context),
        Expanded(
          child: contentListWidget(context),
        ),
      ],
    );
  }

  Widget toolBar(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          children: [
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => addContentDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget contentListWidget(BuildContext context) {
    return HookConsumer(builder: (context, ref, child) {
      final contentNotifiers = ref.watch(contentHubProvider).contentNotifiers;

      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: contentNotifiers.length,
                itemBuilder: (context, index) {
                  final contentNotifier = contentNotifiers[index];

                  return contentItem(contentNotifier);
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget contentItem(ContentNotifier contentNotifier) {
    return HookConsumer(builder: (context, ref, child) {
      useListenable(contentNotifier);

      final awarnessPercent = contentNotifier.awarnessPercent;

      return Card(
        child: InkWell(
          onTap: () {
            ref.read(selectedContentStateProvider.state).state =
                contentNotifier;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const StudyPage()),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      contentNotifier.title,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    ...status2(contentNotifier),
                  ],
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  const Spacer(),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: awarnessPercent.toInt(),
                          child: Container(
                            height: 3,
                            color: Colors.green[300],
                          ),
                        ),
                        Expanded(
                          flex: 100 - awarnessPercent.toInt(),
                          child: Container(
                            height: 3,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> status2(ContentNotifier contentNotifier) {
    return [
      Text(contentNotifier.wordCount),
      const Text(' '),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: contentNotifier.awarnessPercent.toInt() == 100
              ? Colors.green[200]
              : Colors.grey[300],
        ),
        padding: const EdgeInsets.all(2),
        child: Text(
          contentNotifier.awarnessPercent.toStringAsFixed(1) + ' %',
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ];
  }

  List<Widget> status(ContentNotifier contentNotifier) {
    return [
      Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(contentNotifier.allWordCountString),
            const Text(' '),
            Text(
              contentNotifier.awarnessPercentOfAllWord.toStringAsFixed(1) +
                  ' %',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(width: 4),
      Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(contentNotifier.wordCount),
            const Text(' '),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 2.0,
              ),
              child: Text(
                contentNotifier.awarnessPercent.toStringAsFixed(1) + ' %',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
