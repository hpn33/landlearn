import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/word_hub.dart';
import 'package:landlearn/logic/util/util.dart';

import 'ti.dart';
import 'titer.dart';

class WordStatus extends HookConsumerWidget {
  const WordStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final wordHub = ref.read(wordHubProvider);
    useListenable(wordHub);

    final wordCount = wordHub.wordNotifiers.length;
    final wordKnowedCount = wordHub.wordNotifiers.where((e) => e.know).length;

    const scale = 100;
    const padding = 25 * scale;

    final topRange = int.parse(getTopRange(wordCount));
    final belowRange = int.parse(getBelowRange(wordCount));

    final range = topRange - belowRange;

    final fill = ((wordCount - belowRange) / range * 100) * scale;

    final unfill = ((topRange - wordCount) / range * 100) * scale;

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
                    'Total Word',
                    wordCount.toString(),
                  ),
                  titer(
                    'Knowed',
                    wordKnowedCount.toString(),
                  ),
                  titer(
                    'Awarness',
                    (wordKnowedCount / wordCount * 100).toStringAsFixed(2) +
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
                    // text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ti(text: belowRange.toString()),
                        ti(text: wordCount.toString(), show: false),
                        ti(text: topRange.toString()),
                      ],
                    ),
                    // prograss
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
