import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:landlearn/logic/model/word_notifier.dart';

import 'my_overlay_panel.dart';

class MyOverlayPanelWidget extends HookWidget {
  final Widget child;
  final WordNotifier wordNotifier;

  const MyOverlayPanelWidget({
    Key? key,
    required this.child,
    required this.wordNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myOverLayPanel = useMemoized(() => MyOverLayPanel());

    return MouseRegion(
      onEnter: (pointerEnterEvent) {
        myOverLayPanel.showOverlay(context, wordNotifier);
      },
      onExit: (pointerExitEvent) {
        myOverLayPanel.hideOverlay();
      },
      child: CompositedTransformTarget(
        link: myOverLayPanel.layerLink,
        child: child,
      ),
    );
  }
}
