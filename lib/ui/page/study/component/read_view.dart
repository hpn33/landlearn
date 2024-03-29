import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/logic/util/open_browser.dart';
import 'package:landlearn/logic/util/platform_util.dart';
import 'package:landlearn/ui/component/my_overlay_panel_widget.dart';
import 'package:landlearn/ui/component/word_panel.dart';
import 'package:landlearn/ui/component/word_panel_open_widget.dart';
import 'package:landlearn/ui/page/study/logic/view_mode.dart';

import '../study.dart';
import '../logic/study_controller.dart';
import '../logic/read_view_repo.dart';

class ReadView extends HookConsumerWidget {
  const ReadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final contentNotifier = ref.watch(studyVMProvider).selectedContent;

    // load data
    final paragraphs = useState<List<Map<String, WordNotifier?>>>([]);

    useEffect(
      () {
        paragraphs.value = [
          for (final paragraph in contentNotifier.content.split('\n'))
            <String, WordNotifier?>{
              for (final word in paragraph.split(' '))
                word: contentNotifier.getWordNotifier(word),
            },
        ];

        return null;
      },
      [contentNotifier.content],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: ListView.builder(
        padding: const EdgeInsets.only(right: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: paragraphs.value.length,
        itemBuilder: (context, index) {
          final paragraph = paragraphs.value[index];

          return RichText(
            text: paragraphSection(paragraph, contentNotifier),
          );
        },
      ),
    );
  }

  TextSpan paragraphSection(
    Map<String, WordNotifier?> paragraph,
    ContentNotifier contentNotifier,
  ) {
    return TextSpan(
      children: [
        for (final wordRow in paragraph.entries) ...[
          wordSection(contentNotifier, wordRow.key, wordRow.value),
          const TextSpan(
            text: ' ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
      ],
    );
  }

  WidgetSpan wordSection(
    ContentNotifier contentNotifier,
    String word,
    WordNotifier? wordNotifier,
  ) {
    return WidgetSpan(
      child: HookBuilder(
        key: Key(word.isEmpty ? 'empty' : word),
        builder: (context) {
          useListenable(wordNotifier ?? ChangeNotifier());

          if (wordNotifier == null) {
            if (word.isEmpty) {
              return const SizedBox(width: 0);
            }

            if (word.runes.first == 13) {
              return Text(word);
            }

            return Text('($word)');
          }

          return HookConsumer(
            key: Key(contentNotifier.id.toString()),
            builder: (context, ref, child) {
              final viewMode = ref.watch(StudyPage.viewModeProvider);
              final isNormal = viewMode == ViewMode.normal;

              final text = Text(
                word,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              );

              Widget child = _selection(text, wordNotifier, word);

              child = _knowBackgroundColor(
                child,
                isNormal,
                viewMode,
                wordNotifier,
              );

              child = _showSubtitle(
                child,
                ref.watch(StudyPage.showSubtitleProvider),
                wordNotifier,
              );

              return Card(
                margin: const EdgeInsets.all(1),
                elevation: 0,
                color: Colors.grey[100],
                child: _options(
                  child: child,
                  wordNotifier: wordNotifier,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _options({
    required Widget child,
    required WordNotifier wordNotifier,
  }) {
    return Consumer(
      builder: (context, ref, c) {
        final viewMode = ref.watch(StudyPage.viewModeProvider);
        final isNormal = viewMode == ViewMode.normal;

        Widget child0 = child;

        child0 = InkWell(
          onTap: isNormal
              ? () {}
              : () {
                  wordNotifier.toggleKnowToDB(ref);
                },
          onLongPress: () {
            if (isMobile()) {
              ref.read(selectedWordNotifierProvider.notifier).state =
                  wordNotifier;

              showDialog(
                context: context,
                builder: (context) => const WordPanel(),
              );
            } else {
              openGoogleTranslateInBrowser(wordNotifier.word);
            }
          },
          onDoubleTap: () {
            ref.read(studyVMProvider).toggleWordSelection(wordNotifier);
          },
          child: child0,
        );

        if (!ref.watch(StudyPage.showSubtitleProvider) &&
            ref.watch(StudyPage.showOverlayProvider)) {
          child0 = MyOverlayPanelWidget(
            wordNotifier: wordNotifier,
            child: child0,
          );
        }

        return WordPanelOpenWidget(
          wordNotifier: wordNotifier,
          child: child0,
        );
      },
    );
  }

  // Here it is!
  Size _textSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

    return textPainter.size;
  }

  Widget _selection(Widget text, WordNotifier wordNotifier, String word) {
    if (!wordNotifier.selected) {
      return text;
    }

    return Stack(
      children: [
        Positioned(
          bottom: 1,
          child: Container(
            width: _textSize(
              word,
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ).width,
            height: 3,
            color: wordNotifier.selected ? Colors.blue[400] : null,
          ),
        ),
        text,
      ],
    );
  }

  Widget _knowBackgroundColor(
    Widget child,
    bool isNormal,
    ViewMode viewMode,
    WordNotifier wordNotifier,
  ) {
    final decoration = viewMode == ViewMode.unknow
        ? BoxDecoration(
            color: wordNotifier.know ? null : Colors.yellow[200],
            borderRadius: BorderRadius.circular(5),
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        padding: const EdgeInsets.all(0.1),
        decoration: decoration,
        child: child,
      ),
    );
  }

  Widget _showSubtitle(Widget child, bool showMean, WordNotifier wordNotifier) {
    if (!showMean) {
      return child;
    }

    return Column(
      children: [
        child,
        _subtitle(wordNotifier),
      ],
    );
  }

  Widget _subtitle(WordNotifier wordNotifier) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      margin: const EdgeInsets.only(top: 4),
      child: HookConsumer(
        builder: (context, ref, child) {
          final text = ref.watch(repoTranslate(wordNotifier)).when(
                data: (d) => d,
                error: (e, s) => 'err',
                loading: () => '...',
              );

          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
            ),
          );
        },
      ),
    );
  }
}
