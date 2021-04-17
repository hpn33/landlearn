import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Easy to use text widget, which converts inlined urls into clickable links.
/// Allows custom styling.
class TextSelectable extends StatefulWidget {
  /// Text, which may contain inlined urls.
  final String text;

  /// Style of the non-url part of supplied text.
  final TextStyle textStyle;

  /// Style of the url part of supplied text.
  final TextStyle linkStyle;

  /// Determines how the text is aligned.
  final TextAlign textAlign;

  /// Creates a [TextSelectable] widget, used for inlined urls.
  const TextSelectable({
    Key key,
    @required this.text,
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
  })  : assert(text != null),
        super(key: key);

  @override
  _TextSelectableState createState() => _TextSelectableState();
}

class _TextSelectableState extends State<TextSelectable> {
  List<TapGestureRecognizer> _gestureRecognizers;
  final RegExp _regex = RegExp(r"(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

  @override
  void initState() {
    super.initState();
    _gestureRecognizers = <TapGestureRecognizer>[];
  }

  @override
  void dispose() {
    _gestureRecognizers.forEach((recognizer) => recognizer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyle = this.widget.textStyle ?? themeData.textTheme.bodyText2;
    // final linkStyle = this.widget.linkStyle ??
    //     themeData.textTheme.bodyText2.copyWith(
    //       color: themeData.accentColor,
    //       decoration: TextDecoration.underline,
    //     );

    final wordsBox = Hive.box('words');

    final others = _regex.allMatches(widget.text);

    if (others.isEmpty) {
      return Text(widget.text, style: textStyle);
    }

    final words = widget.text.split(_regex);
    final textSpans = <TextSpan>[];

    int i = 0;
    others.forEach((other) {
      textSpans.add(TextSpan(text: other.group(0), style: textStyle));

      if (i < words.length) {
        final word = words[i].toLowerCase();
        final wordState = wordsBox.get(word);

        final recognizer = TapGestureRecognizer()
          ..onTapDown = (d) {
            wordsBox.put(word, wordState == 0 ? 1 : 0);
            // final p = d.globalPosition;

            // return ShowMoreTextPopup(
            //   context,
            //   text: word + ' $wordState',
            //   width: 100,
            //   height: 50,
            // ).show(rect: Rect.fromLTRB(p.dx, p.dy, p.dx + 1, p.dy + 1));
          };

        _gestureRecognizers.add(recognizer);

        textSpans.add(
          TextSpan(
            text: word,
            // style: linkStyle,
            style: TextStyle(
              color: wordState == 0 ? Colors.grey : Colors.green,
            ),
            recognizer: recognizer,
          ),
        );

        i++;
      }
    });

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: widget.textAlign,
    );
  }
}
