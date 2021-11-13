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
            Spacer(),
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
      ),
    );
  }

  Widget contentListWidget(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final contentNotifiers = watch(contentHubProvider).contentNotifiers;

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
    return HookBuilder(builder: (context) {
      useListenable(contentNotifier);

      return Card(
        child: InkWell(
          onTap: () {
            context.read(selectedContentStateProvider).state = contentNotifier;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => StudyPage()),
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
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 2.0,
                      ),
                      child: Text(
                        contentNotifier.awarnessPercent.toStringAsFixed(1) +
                            ' %',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    Spacer(),
                    Spacer(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: contentNotifier.awarnessPercent.toInt(),
                            child: Container(
                              height: 3,
                              color: Colors.green[300],
                            ),
                          ),
                          Expanded(
                            flex: 100 - contentNotifier.awarnessPercent.toInt(),
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
