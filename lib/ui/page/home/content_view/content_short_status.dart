import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/util/screen_size.dart';

class ContentShortStatus extends ConsumerWidget {
  const ContentShortStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    if (!screenSize(context).isCompactScreen) {
      return const SizedBox();
    }

    final contentHub = ref.watch(contentHubProvider);

    return Card(
      margin: const EdgeInsets.all(0.0),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                const Text('count'),
                Text(
                  '${contentHub.contentNotifiers.length}',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                const Text('awarness'),
                Text(
                  '${contentHub.awarness.toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
