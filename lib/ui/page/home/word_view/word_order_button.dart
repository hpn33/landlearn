import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/util/menu_position.dart';

import 'word_view.dart';

class WordOrderButton extends ConsumerWidget {
  const WordOrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final order = ref.watch(WordView.orderProvider.notifier);

    return ActionChip(
      avatar: const Icon(Icons.filter_list),
      label: Text(order.state),
      backgroundColor: Colors.white,
      onPressed: () {
        final position = buttonMenuPosition(context);

        showMenu<String>(
          context: context,
          position: position,
          initialValue: order.state,
          items: [
            PopupMenuItem(
              value: 'Norm',
              onTap: () {
                order.state = 'Norm';
              },
              child: const Text('Norm'),
            ),
            PopupMenuItem(
              value: 'Most',
              onTap: () {
                order.state = 'Most';
              },
              child: const Text('Most'),
            ),
            PopupMenuItem(
              value: 'Last',
              onTap: () {
                order.state = 'Last';
              },
              child: const Text('Last'),
            ),
          ],
        );
      },
    );
  }
}
