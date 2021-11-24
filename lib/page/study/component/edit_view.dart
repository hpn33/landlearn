import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditView extends HookConsumerWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final textController = ref.watch(textControllerProvider);
    final contentNotifier = ref.read(selectedContentStateProvider);

    useListenable(contentNotifier!);

    return Column(
      children: [
        // status card
        panel(ref, textController, contentNotifier),
        Expanded(
          child: SingleChildScrollView(
            child: TextField(
              controller: textController,
              minLines: 20,
              maxLines: 1000,
            ),
          ),
        ),
      ],
    );
  }

  Widget panel(
    WidgetRef ref,
    TextEditingController textController,
    ContentNotifier contentNotifier,
  ) {
    if (textController.text != contentNotifier.content) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  textController.text = contentNotifier.content;
                },
              ),
              IconButton(
                icon: const Icon(Icons.done),
                onPressed: () async {
                  ref
                      .read(selectedContentStateProvider)!
                      .updateContent(ref.read(textControllerProvider).text);

                  await analyze(ref);
                },
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
