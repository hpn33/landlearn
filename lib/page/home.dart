import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:landlearn/hive/project.dart';
import 'package:landlearn/hive/word.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final projectBox = Hive.box<ProjectObj>('projects');
    useListenable(projectBox.listenable());
    final projects = projectBox.values.toList();

    return Material(
      child: SafeArea(
        child: Column(
          children: [
            topBar(context),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: contents(context, projects)),
                  SizedBox(width: 15),
                  Expanded(child: words(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contents(BuildContext context, List<ProjectObj> projects) {
    return Column(
      children: [
        Text('Content'),
        Divider(),
        Expanded(
          child: GridView.builder(
            itemCount: projects.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              final project = projects[index];

              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => StudyPage(project),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        '${project.title}',
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

  Widget words(BuildContext context) {
    final words = Hive.box<WordObj>('words').values.toList()
      ..sort((a, b) => a.word.compareTo(b.word));

    return Column(
      children: [
        Text('Words'),
        Divider(),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final word in words) Text(word.word),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget topBar(BuildContext context) {
    return Material(
      elevation: 6,
      child: Row(
        children: [
          TextButton(
            child: Text('create'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (cox) => addContentDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
