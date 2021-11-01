import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/page/home/content_view/content_view_vm.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';

class ContentView extends HookWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final vm = useProvider(contentViewVM);

    // useListenable(vm.contentLists);

    // useEffect(() {
    //   vm.init();
    // }, []);

    final contentList = useProvider(contentsListProvider).state;

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
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final content in contentList)
                        contentItem(context, content),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget contentItem(BuildContext context, Content content) {
    return Card(
      child: InkWell(
        onTap: () {
          context.read(selectedContentProvider).state = content.id;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => StudyPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(content.title),
              // Spacer(),
              // Text(contentData.awarnessPercent.toStringAsFixed(1) + '%'),
            ],
          ),
        ),
      ),
    );
  }
}
