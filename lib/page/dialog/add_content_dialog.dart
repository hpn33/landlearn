import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/content_view/content_view.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/analyze_content.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/util/sample.dart';

Widget addContentDialog() {
  return Dialog(
    child: HookConsumer(
      builder: (context, ref, child) {
        final controller = useTextEditingController();
        final useSample = useState(false);

        return Container(
          width: 500,
          height: 300,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('content'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final db = ref.read(dbProvider);

                      final content = await db.contentDao.add(
                        controller.text,
                        useSample.value ? sample : '',
                      );

                      final contentHub = ref.read(contentHubProvider);
                      final wordHub = ref.read(wordHubProvider);

                      final contentNotifier =
                          contentHub.addContent(content, wordHub);
                      contentHub.notify();

                      await analyzeContent(db, contentNotifier, wordHub);

                      final index = contentHub.contentNotifiers.length - 1;
                      ContentView.animatedListKey.currentState!
                          .insertItem(index);

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              const Text('title'),
              TextField(controller: controller),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('use Sample'),
                  Checkbox(
                    value: useSample.value,
                    onChanged: (v) => useSample.value = v!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
