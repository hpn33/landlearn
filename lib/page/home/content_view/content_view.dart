import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/page/home/content_view/content_view_vm.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/models/content_notifier.dart';

class ContentView extends StatelessWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => addContentDialog(),
                );
              },
            )
          ],
        ),
        Expanded(
          child: contentListWidget(context),
        ),
      ],
    );
  }

  Widget contentListWidget(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final contentNotifiers = watch(getContentNotifiersStateProvider).state;

      return Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final contentNotifier in contentNotifiers)
                    contentItem(contentNotifier),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget contentItem(ContentNotifier contentNotifier) {
    return HookBuilder(builder: (context) {
      useListenable(contentNotifier);

      return Card(
        child: InkWell(
          onTap: () {
            contentNotifier.selectAndLoad();

            context.read(selectedContentStateProvider).state = contentNotifier;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => StudyPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(contentNotifier.title),
                Spacer(),
                Text(contentNotifier.awarnessPercent.toStringAsFixed(1) + '%'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
