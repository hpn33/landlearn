import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/page/home/content_view/content_view_vm.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/model/content_data.dart';

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
      final contentDataList = watch(contentDatasListProvider).state;

      return Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final content in contentDataList)
                    contentItem(context, content),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget contentItem(BuildContext context, ContentData contentData) {
    return Card(
      child: InkWell(
        onTap: () {
          context.read(selectedContentIdProvider).state =
              contentData.content.id;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => StudyPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(contentData.content.title),
              Spacer(),
              Text(contentData.awarnessPercent.toStringAsFixed(1) + '%'),
            ],
          ),
        ),
      ),
    );
  }
}
