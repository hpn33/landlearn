import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        final titleController = useTextEditingController();
        final textController = useTextEditingController();
        // final useSample = useState(false);

        return Container(
          width: 700,
          height: 500,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              titleController.text,
                              textController.text,
                            );

                            final contentHub = ref.read(contentHubProvider);
                            final wordHub = ref.read(wordHubProvider);

                            final contentNotifier =
                                contentHub.addContent(content, wordHub);
                            contentHub.notify();

                            await analyzeContent(db, contentNotifier, wordHub);

                            final index =
                                contentHub.contentNotifiers.length - 1;
                            ContentView.animatedListKey.currentState!
                                .insertItem(index);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text('title'),
                    TextField(controller: titleController),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('use Sample'),
                        ElevatedButton(
                          onPressed: () {
                            textController.text = sample;
                          },
                          child: const Text('Use'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Text'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.cleaning_services_outlined),
                          onPressed: () {
                            textController.clear();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.content_paste),
                          onPressed: () async {
                            final a =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            textController.text = a!.text ?? '';
                          },
                        ),
                      ],
                      // ),
                      // ],
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          // border: Border.all(color: Colors.grey[300]),
                        ),
                        child: TextField(
                          controller: textController,
                          expands: true,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
