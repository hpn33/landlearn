import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/component/knowlage_view.dart';
import 'package:landlearn/service/providers.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/open_browser.dart';
import 'package:landlearn/util/open_study_page.dart';

class WordPanel extends StatelessWidget {
  const WordPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Material(
        child: SizedBox(
          width: 500,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  wordSection(),
                  translateSection(),
                  const Divider(),
                  noteSection(),
                  refsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget wordSection() => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final word = ref.read(selectedWordNotifierProvider)!.word;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(word, style: const TextStyle(fontSize: 24)),
                const Spacer(),
              ],
            ),
          );
        },
      );

  Widget translateSection() => Consumer(
        builder: (context, ref, child) {
          final wordNotifier = ref.read(selectedWordNotifierProvider)!;
          final translate = ref.watch(repoTranslate(wordNotifier)).when(
              data: (d) => d, error: (e, s) => 'err', loading: () => '...');

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      openGoogleTranslateInBrowser(wordNotifier.word),
                  child: const Text('Google Translation'),
                ),
                Text(translate),
              ],
            ),
          );
        },
      );

  Widget noteSection() => HookConsumer(
        builder: (context, ref, child) {
          final wordNotifier = ref.read(selectedWordNotifierProvider)!;
          useListenable(wordNotifier);

          final note = wordNotifier.note ?? '';
          final noteIsEmpty = note.isEmpty;

          final show = useState(false);

          final textController = useTextEditingController(text: note);

          useEffect(
            () {
              textController.text = note;
            },
            [note],
          );

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                if (noteIsEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => const EditNotePanel(),
                  );
                  return;
                }

                show.value = !show.value;
              },
              onDoubleTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const EditNotePanel(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 100),
                  child: show.value
                      ? Text(textController.text)
                      : noteIsEmpty
                          ? const Text(
                              'empty note',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          : Row(
                              children: [
                                Text(
                                  textController.text,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const Spacer(),
                                if (note.contains('\n')) const Text('...'),
                              ],
                            ),
                ),
              ),
            ),
          );
        },
      );

  Widget refsSection() => HookConsumer(
        builder: (context, ref, child) {
          final selectedWordNotifier = ref.read(selectedWordNotifierProvider)!;
          final refs = selectedWordNotifier.contentCatch.values;

          final show = useState(false);

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    show.value = !show.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('refs'),
                        const Spacer(),
                        Text('${refs.length}'),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  child: show.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              for (final contentNotifier in refs)
                                InkWell(
                                  onTap: () {
                                    openStudyPage(
                                        context, ref, contentNotifier);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(contentNotifier.title),
                                        const Spacer(),
                                        Text(selectedWordNotifier
                                            .getContentCount(contentNotifier.id)
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          );
        },
      );
}

class EditNotePanel extends HookConsumerWidget {
  const EditNotePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final selectedWordNotifier = ref.read(selectedWordNotifierProvider)!;
    useListenable(selectedWordNotifier);

    final note = selectedWordNotifier.note ?? '';

    final showAction = useState(false);

    final textController = useTextEditingController(text: note);
    useListenable(textController);

    useEffect(
      () {
        if (textController.text != note) {
          textController.text = note;
        }

        showAction.value = textController.text != note;
      },
      [note],
    );

    useEffect(
      () {
        showAction.value = textController.text != note;
      },
      [textController.text],
    );

    return Dialog(
      child: SizedBox(
        width: 300,
        height: 400,
        child: Material(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  if (showAction.value) ...[
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        textController.text = selectedWordNotifier.note ?? '';
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.done),
                      onPressed: () {
                        selectedWordNotifier.updateNoteToDB(
                          ref,
                          textController.text,
                        );
                      },
                    ),
                  ],
                ],
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  expands: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
