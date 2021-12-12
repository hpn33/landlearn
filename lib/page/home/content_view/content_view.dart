import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/dialog/add_content_dialog.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/util/open_study_page.dart';
import 'package:landlearn/widget/styled_percent_widget.dart';

class ContentView extends StatelessWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _wordStatus(),
          _contentStatus(),
          const SizedBox(height: 15),
          toolBar(context),
          // const SizedBox(height: 10),
          Expanded(
            child: contentListWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _wordStatus() => SizedBox(
        height: 120,
        child: HookConsumer(
          builder: (BuildContext context, ref, child) {
            final wordHub = ref.read(wordHubProvider);
            useListenable(wordHub);

            final wordCount = wordHub.wordNotifiers.length;
            final wordKnowedCount =
                wordHub.wordNotifiers.where((e) => e.know).length;

            // final awarness = wordHub.wordNotifiers
            //         .map((e) => e.awarnessPercentOfAllWord)
            //         .fold<double>(0.0,
            //             (previousValue, element) => previousValue + element) /
            //     contentHub.contentNotifiers.length;

            const scale = 100;
            const padding = 25 * scale;

            final topRange = int.parse(getTopRange(wordCount));
            final belowRange = int.parse(getBelowRange(wordCount));

            final range = topRange - belowRange;

            final fill = ((wordCount - belowRange) / range * 100) * scale;

            final unfill = ((topRange - wordCount) / range * 100) * scale;

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        titer(
                          'Total Word',
                          wordCount.toString(),
                        ),
                        titer(
                          'Knowed',
                          wordKnowedCount.toString(),
                        ),
                        titer(
                          'Awarness',
                          (wordKnowedCount / wordCount * 100)
                                  .toStringAsFixed(2) +
                              '%',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(belowRange.toString()),
                                  Container(
                                    width: 2,
                                    height: 5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(wordCount.toString()),
                                  const SizedBox(
                                    width: 2,
                                    height: 5,
                                    // color: Colors.grey,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(topRange.toString()),
                                  Container(
                                    width: 2,
                                    height: 5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 10,
                            child: Row(
                              children: [
                                // Expanded(
                                //   flex: 17,
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: Colors.red[400],
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  flex: padding + fill.toInt()
                                  // 66
                                  ,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:
                                      //66
                                      padding + unfill.toInt(),
                                  child: const SizedBox(),
                                ),
                                // Expanded(
                                //   flex: 17,
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: Colors.red[400],
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

  Widget _contentStatus() => SizedBox(
        height: 120,
        child: HookConsumer(
          builder: (BuildContext context, ref, child) {
            final contentHub = ref.read(contentHubProvider);
            useListenable(contentHub);

            final awarness = contentHub.contentNotifiers
                    .map((e) => e.awarnessPercentOfAllWord)
                    .fold<double>(0.0,
                        (previousValue, element) => previousValue + element) /
                contentHub.contentNotifiers.length;

            const scale = 100;
            const padding = 25 * scale;

            final topRange =
                int.parse(getTopRange(contentHub.contentNotifiers.length));
            final belowRange =
                int.parse(getBelowRange(contentHub.contentNotifiers.length));

            final range = topRange - belowRange;

            final fill = ((contentHub.contentNotifiers.length - belowRange) /
                    range *
                    100) *
                scale;

            final unfill = ((topRange - contentHub.contentNotifiers.length) /
                    range *
                    100) *
                scale;

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        titer(
                          'Total Content',
                          contentHub.contentNotifiers.length.toString(),
                        ),
                        titer(
                          'Awarness',
                          awarness.toStringAsFixed(2) + '%',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(getBelowRange(
                                      contentHub.contents.length)),
                                  Container(
                                    width: 2,
                                    height: 5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(contentHub.contents.length.toString()),
                                  const SizedBox(
                                    width: 2,
                                    height: 5,
                                    // color: Colors.grey,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(getTopRange(contentHub.contents.length)),
                                  Container(
                                    width: 2,
                                    height: 5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 10,
                            child: Row(
                              children: [
                                // Expanded(
                                //   flex: 17,
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: Colors.red[400],
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  flex: padding + fill.toInt()
                                  // 66
                                  ,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:
                                      //66
                                      padding + unfill.toInt(),
                                  child: const SizedBox(),
                                ),
                                // Expanded(
                                //   flex: 17,
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: Colors.red[400],
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

  Widget titer(String title, String number) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget toolBar(BuildContext context) {
    return
        //  Card(
        // child:
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          // Consumer(
          //   builder: (context, ref, child) {
          //     final count =
          //         ref.watch(contentHubProvider).contentNotifiers.length;

          //     return Text('$count');
          //   },
          // ),
          const Text(
            'Contents',
            style: TextStyle(fontSize: 16),
          ),
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
      // ),
    );
  }

  Widget contentListWidget(BuildContext context) => HookConsumer(
        builder: (context, ref, child) {
          final contentNotifiers =
              ref.watch(contentHubProvider).contentNotifiers;

          final scrollController = useScrollController();
          return Scrollbar(
            controller: scrollController,
            isAlwaysShown: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: contentNotifiers.length,
                itemBuilder: (context, index) {
                  final contentNotifier = contentNotifiers[index];

                  return contentItem(contentNotifier);
                },
              ),
            ),
          );
        },
      );

  Widget contentItem(ContentNotifier contentNotifier, [int index = -1]) {
    return HookConsumer(builder: (context, ref, child) {
      useListenable(contentNotifier);

      final awarnessPercent = contentNotifier.awarnessPercent;
      final awarnessPercentOfAllWord = contentNotifier.awarnessPercentOfAllWord;

      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () {
            openStudyPage(context, ref, contentNotifier);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        contentNotifier.title,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    ...status2(contentNotifier),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () async {
                            await contentNotifier.removeWithDB(ref);
                          },
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              Text(
                                ' Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: awarnessPercentOfAllWord.toInt(),
                              child: Container(
                                height: 3,
                                color: Colors.green[300],
                              ),
                            ),
                            Expanded(
                              flex: 100 - awarnessPercentOfAllWord.toInt(),
                              child: Container(
                                height: 3,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Expanded(
                              flex: awarnessPercent.toInt(),
                              child: Container(
                                height: 3,
                                color: Colors.blue[300],
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
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
      Text(contentNotifier.allWordCount.toString()),
      const Text(' '),
      StyledPercent(
        awarnessPercent: contentNotifier.awarnessPercentOfAllWord,
        color: Colors.blue[100],
      ),
      const Text(' '),
      Text(contentNotifier.wordCount.toString()),
      const Text(' '),
      StyledPercent(awarnessPercent: contentNotifier.awarnessPercent),
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
            Text(contentNotifier.wordCount.toString()),
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

  String getBelowRange(int length) {
    final s = length.toString();

    if (s.length == 1) {
      return '0';
    }

    return s.substring(0, 1) +
        List.generate(s.length - 1, (index) => '0').join();
  }

  String getTopRange(int length) {
    final s = length.toString();
    final fn = int.parse(s.substring(0, 1));

    if (s.length == 1) {
      return '10';
    }
    return (fn + 1).toString() +
        List.generate(s.length - 1, (index) => '0').join();
  }
}
