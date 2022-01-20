import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/logic/util/open_study_page.dart';
import 'package:landlearn/ui/component/styled_percent_widget.dart';

class ContentItem extends HookConsumerWidget {
  final ContentNotifier contentNotifier;

  const ContentItem(this.contentNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useListenable(contentNotifier);

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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contentNotifier.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      // ...status2(contentNotifier),
                      // Column(children: status3(contentNotifier)),
                      // SizedBox(
                      //   width: 60,
                      //   child: percentStatus(contentNotifier),
                      // ),

                      _popupMenu(),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(),
                  // status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _status4(contentNotifier),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     const Spacer(),
            //     const Spacer(),
            //     const Spacer(),
            //     Expanded(
            //       child: percentStatus(contentNotifier),
            //     ),
            //     const SizedBox(width: 4),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> status3(ContentNotifier contentNotifier) {
    return [
      Row(
        children: [
          Text(contentNotifier.wordCount.toString()),
          const Text(' '),
          StyledPercent(
            awarnessPercent: contentNotifier.awarnessPercent,
            color: Colors.blue[100],
          ),
        ],
      ),

      const SizedBox(height: 2),
      SizedBox(width: 60, child: percentStatus(contentNotifier)),
      const SizedBox(height: 2),

      Row(children: [
        Text(contentNotifier.allWordCount.toString()),
        const Text(' '),
        StyledPercent(
            awarnessPercent: contentNotifier.awarnessPercentOfAllWord),
      ]),

      // const Text(' '),
    ];
  }

  List<Widget> _status4(ContentNotifier contentNotifier) {
    return [
      // SizedBox(width: 60, child: percentStatus(contentNotifier)),
      //
      const SizedBox(width: 2),

      Row(
        children: [
          Text(contentNotifier.wordCount.toString()),
          const Text(' '),
          StyledPercent(
            awarnessPercent: contentNotifier.awarnessPercent,
            color: Colors.blue[100],
          ),
        ],
      ),

      const SizedBox(width: 2),

      Row(children: [
        Text(contentNotifier.allWordCount.toString()),
        const Text(' '),
        StyledPercent(
            awarnessPercent: contentNotifier.awarnessPercentOfAllWord),
      ]),
      // const SizedBox(width: 2),

      // const Text(' '),
    ];
  }

  List<Widget> status2(ContentNotifier contentNotifier) {
    return [
      Text(contentNotifier.allWordCount.toString()),
      const Text(' '),
      StyledPercent(awarnessPercent: contentNotifier.awarnessPercentOfAllWord),
      const Text(' '),
      Text(contentNotifier.wordCount.toString()),
      const Text(' '),
      StyledPercent(
        awarnessPercent: contentNotifier.awarnessPercent,
        color: Colors.blue[100],
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

  Widget percentStatus(ContentNotifier contentNotifier) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              flex: contentNotifier.awarnessPercent.toInt(),
              child: Container(
                height: 3,
                color: Colors.blue[300],
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
        //
        const SizedBox(height: 1),
        //
        Row(
          children: [
            Expanded(
              flex: contentNotifier.awarnessPercentOfAllWord.toInt(),
              child: Container(
                height: 3,
                color: Colors.green[300],
              ),
            ),
            Expanded(
              flex: 100 - contentNotifier.awarnessPercentOfAllWord.toInt(),
              child: Container(
                height: 3,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _popupMenu() {
    return Consumer(
      builder: (BuildContext context, ref, child) {
        return PopupMenuButton(
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
        );
      },
    );
  }
}
