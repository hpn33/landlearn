import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';

import '../logic/study_controller.dart';

class EditView extends StatelessWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(child: textField()),
        ),
        const EditPanel(),
      ],
    );
  }

  Widget textField() => Consumer(
        builder: (context, ref, child) {
          final textController = ref.watch(textControllerProvider);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: TextField(
              controller: textController,
              minLines: 20,
              maxLines: 1000,
            ),
          );
        },
      );
}

class EditPanel extends HookConsumerWidget {
  const EditPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final textController = ref.watch(textControllerProvider);
    final contentNotifier = ref.read(studyVMProvider).selectedContent;

    useListenable(contentNotifier);

    if (textController.text == contentNotifier.content) {
      return const SizedBox();
    }

    return panel(textController, contentNotifier);
  }

  Widget panel(
    TextEditingController textController,
    ContentNotifier contentNotifier,
  ) {
    return HookBuilder(builder: (context) {
      final animationController = useAnimationController(
        duration: const Duration(milliseconds: 150),
      );

      useEffect(
        () {
          animationController.forward();

          return null;
        },
        [],
      );

      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
        child: Card(
          color: Colors.orange[100],
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
                Consumer(builder: (context, ref, child) {
                  return IconButton(
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      ref.read(studyVMProvider).updateContent(ref);

                      await analyze(ref);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
