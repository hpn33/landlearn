import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/content_notifier.dart';

import 'content_view/content_view.dart';
import 'word_view/word_view.dart';

class DeskHomePage extends StatelessWidget {
  const DeskHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1140,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              children: [
                _status(),
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: const [
                Expanded(flex: 4, child: WordView()),
                Expanded(flex: 3, child: ContentView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _status() => HookConsumer(
        builder: (BuildContext context, ref, child) {
          final contentHub = ref.read(contentHubProvider);

          final awarness = contentHub.contentNotifiers
                  .map((e) => e.awarnessPercentOfAllWord)
                  .fold<double>(0.0,
                      (previousValue, element) => previousValue + element) /
              contentHub.contentNotifiers.length;

          return Expanded(
            child: Container(
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
                          contentHub.contents.length.toString(),
                        ),
                        titer(
                          'Awarness',
                          awarness.toStringAsFixed(2),
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
                      child: Row(
                        children: const [],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget titer(String title, String number) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
