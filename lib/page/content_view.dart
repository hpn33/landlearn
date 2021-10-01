import 'package:flutter/material.dart';

class ContentView extends StatelessWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: contents(context),
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
}
