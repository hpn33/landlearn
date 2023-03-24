import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/util/analyze_content.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/word_hub.dart';
import 'package:landlearn/logic/util/sample.dart';
import 'package:subtitle/subtitle.dart';

Widget addContentDialog() {
  return Dialog(
    child: HookConsumer(
      builder: (context, ref, child) {
        final titleController = useTextEditingController();
        final textController = useTextEditingController();

        final isDrop = useState(false);

        return DropTarget(
          onDragDone: (data) async {
            final file = File(data.files.first.path);

            final subtitleProvider = SubtitleProvider.fromFile(file);
            final controller = SubtitleController(provider: subtitleProvider);

            titleController.text = data.files.first.name;

            controller
                .initial()
                .whenComplete(
                  () => textController.text = controller.getAll('\n\n'),
                )
                .onError(
                  (error, stackTrace) async =>
                      textController.text = await file.readAsString(),
                );
          },
          onDragEntered: (details) {
            isDrop.value = true;
          },
          onDragExited: (details) {
            isDrop.value = false;
          },
          child: SizedBox(
            width: 700,
            height: 500,
            child: Stack(
              children: [
                _form(isDrop, textController, ref, titleController, context),
                if (isDrop.value)
                  Positioned.fill(child: _overlay(isDrop.value)),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _form(
  ValueNotifier<bool> isDrop,
  TextEditingController textController,
  WidgetRef ref,
  TextEditingController titleController,
  BuildContext context,
) {
  return Container(
    color: isDrop.value ? Colors.grey[200] : Colors.white,
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
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
                      final a = await Clipboard.getData(Clipboard.kTextPlain);
                      textController.text = a!.text ?? '';
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
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
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('content'),
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () async {
                      final db = ref.read(dbProvider);

                      final content = await db.contentDao.add(
                        titleController.text,
                        textController.text,
                      );

                      final contentHub = ref.read(contentHubProvider);
                      final wordHub = ref.read(wordHubProvider);

                      final contentNotifier =
                          contentHub.addByContent(content, wordHub);
                      contentHub.notify();

                      await analyzeContent(db, contentNotifier, wordHub);

                      if (context.mounted) Navigator.pop(context);
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
              const Spacer(),
              const Text(
                '* Drop Subtitle ( vtt, srt, sbv, ssa, ttml, dfxp )',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _overlay(bool isDrag) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 50),
    color: isDrag ? Colors.grey[300]!.withOpacity(.8) : Colors.transparent,
    child: isDrag
        ? FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'DROP',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        : const SizedBox(),
  );
}
