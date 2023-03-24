import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/word_hub.dart';
import 'package:landlearn/logic/util/util.dart';

import 'ti.dart';
import 'titer.dart';

class ContentStatus extends HookConsumerWidget {
  const ContentStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentHub = ref.read(contentHubProvider);
    useListenable(contentHub);

    final wordHub = ref.read(wordHubProvider);
    useListenable(wordHub);

    const scale = 100;
    const padding = 25 * scale;

    final topRange = int.parse(getTopRange(contentHub.contentNotifiers.length));
    final belowRange =
        int.parse(getBelowRange(contentHub.contentNotifiers.length));

    final range = topRange - belowRange;

    final fill =
        ((contentHub.contentNotifiers.length - belowRange) / range * 100) *
            scale;

    final unfill =
        ((topRange - contentHub.contentNotifiers.length) / range * 100) * scale;

    return SizedBox(
      height: 120,
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
                    contentHub.contentNotifiers.length.toString(),
                  ),
                  titer(
                    'Awarness',
                    '${contentHub.awarness.toStringAsFixed(2)}%',
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
                    // text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ti(text: getBelowRange(contentHub.contents.length)),
                        ti(
                          text: contentHub.contents.length.toString(),
                          show: false,
                        ),
                        ti(text: getTopRange(contentHub.contents.length)),
                      ],
                    ),
                    // progress bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 10,
                      child: Row(
                        children: [
                          Expanded(
                            flex: padding + fill.toInt(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: padding + unfill.toInt(),
                            child: const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
