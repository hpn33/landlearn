import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:landlearn/hive/project.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/util/sample.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProjectPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(Hive.box('projects').listenable());
    final projects = Hive.box('projects').values.toList();

    return Material(
      child: SafeArea(
        child: Column(
          children: [
            topBar(),
            Expanded(
              child: GridView.builder(
                itemCount: projects.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300),
                itemBuilder: (context, index) {
                  final project = projects[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                StudyPage(project),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text('Title ${project.title}'),
                          Text('word count: 1654'),
                          Text('match with me: %80'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topBar() {
    return Material(
      elevation: 6,
      child: Row(
        children: [
          TextButton(
            child: Text('create'),
            onPressed: () {
              Hive.box('projects').add(
                ProjectObj()
                  ..title = 'test'
                  ..text = sample,
              );
            },
          ),
        ],
      ),
    );
  }
}
