import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/service/providers.dart';

import 'word_panel.dart';

class WordPanelOpenWidget extends ConsumerWidget {
  final Widget child;
  final WordNotifier wordNotifier;

  const WordPanelOpenWidget({
    Key? key,
    required this.child,
    required this.wordNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Listener(
      onPointerDown: (pd) => onRightClickOpenWordPanel(pd, context, ref),
      child: child,
    );
  }

  void onRightClickOpenWordPanel(
    PointerDownEvent event,
    BuildContext context,
    WidgetRef ref,
  ) {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      wordNotifier.updateTime(ref);

      ref.read(selectedWordNotifierProvider.state).state = wordNotifier;

      showDialog(
        context: context,
        builder: (context) => const WordPanel(),
      );
    }
  }
}
