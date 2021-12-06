import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/component/knowlage_view.dart';
import 'package:landlearn/service/providers.dart';

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

          return Row(
            children: [
              Text(word),
            ],
          );
        },
      );

  Widget translateSection() => Consumer(
        builder: (context, ref, child) {
          final wordNotifier = ref.read(selectedWordNotifierProvider)!;
          final translate = ref.watch(repoTranslate(wordNotifier)).when(
              data: (d) => d, error: (e, s) => 'err', loading: () => '...');

          return Row(
            children: [
              const Spacer(),
              Text(translate),
            ],
          );
        },
      );

  Widget noteSection() => HookConsumer(
        builder: (context, ref, child) {
          final note = ref.read(selectedWordNotifierProvider)!.note;

          final show = useState(false);

          final textController = useTextEditingController(
              text: note != null
                  ? note.isNotEmpty
                      ? note
                      : 'Note'
                  : ' Note');

          // final sampleText = useState(
          //     'a long long text that is here to you can see what is for, a long long text that is here to you can see what is for,a long long text that is here to you can see what is for, a long long text that is here to you can see what is for');

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                show.value = !show.value;
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 150),
                      child: show.value
                          ? Text(textController.text)
                          : Text(
                              textController.text,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget refsSection() => HookBuilder(
        builder: (context) {
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
                      children: const [
                        Text('refs'),
                        Spacer(),
                        Text('99'),
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
                            children: const [
                              Text('refs'),
                              Text('refs'),
                              Text('refs'),
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
