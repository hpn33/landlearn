import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:landlearn/ui/page/study/component/read_view_repo.dart';

/// this three should be set
/// ----
/// showOverlay
/// hideOverlay
/// layerLink
class MyOverLayPanel {
  OverlayEntry? overlayEntry;
  final layerLink = LayerLink();

  void showOverlay(BuildContext context, WordNotifier word) {
    if (overlayEntry != null) {
      return;
    }

    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 150,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: buildOverlay(context, word),
        ),
      ),
    );

    overlay.insert(overlayEntry!);
  }

  void hideOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  Widget buildOverlay(BuildContext context, WordNotifier wordNotifier) {
    return HookConsumer(builder: (context, ref, child) {
      return Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(4),
          width: 50,
          height: 50,
          child: Text(
            ref.watch(repoTranslate(wordNotifier)).when(
                  data: (d) => d,
                  error: (e, s) => 'err',
                  loading: () => '...',
                ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }
}
