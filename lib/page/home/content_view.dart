import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/db/database.dart';

final contentsP =
    StreamProvider((ref) => ref.read(dbProvider).contentDao.watching());

class ContentView extends HookWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: contents2(context),
    );
  }

  Widget contents(
    BuildContext context,
    // List<ProjectObj> projects
  ) {
    return Column(
      children: [
        Text('Content'),
        Divider(),
        Expanded(
          child: GridView.builder(
            itemCount: 0, //projects.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              // final project = projects[index];

              return Card(
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => StudyPage(project),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Text(
                        '',
                        // '${project.title}',
                        style: TextStyle(fontSize: 22),
                      ),
                      Divider(),
                      Text('word count: 1654'),
                      Text('undrestand: %80'),
                      Spacer(),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       icon: Icon(Icons.delete),
                      //       onPressed: () {
                      //         project.delete();
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget contents2(BuildContext context) {
    final contentsFuture = useProvider(contentsP);

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
                      ...contentsFuture.when(
                        data: (List<Content> contents) => [
                          for (final content in contents)
                            contentItem(context, content),
                        ],
                        loading: () => [CircularProgressIndicator()],
                        error: (Object error, StackTrace? stackTrace) => [
                          Text('$error || $stackTrace'),
                        ],
                      ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => StudyPage(content)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(content.title),
              Spacer(),
              Text('100% (not Impl)'),
            ],
          ),
        ),
      ),
    );
  }
}
