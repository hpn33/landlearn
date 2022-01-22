import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/util/menu_position.dart';

import 'content_view.dart';

class ContentOrderButton extends ConsumerWidget {
  const ContentOrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final order = ref.watch(ContentView.orderProvider.state);

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
              child: const Text('Norm'),
              value: 'Norm',
              onTap: () {
                order.state = 'Norm';
              },
            ),
            PopupMenuItem(
              child: const Text('Last'),
              value: 'Last',
              onTap: () {
                order.state = 'Last';
              },
            ),
          ],
        );
      },
    );
  }
}
