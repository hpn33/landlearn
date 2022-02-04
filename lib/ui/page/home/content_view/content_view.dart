import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/ui/component/search_box.dart';
import 'package:landlearn/ui/float/add_content_dialog.dart';

import 'content_item.dart';
import 'content_order_button.dart';
import 'content_short_status.dart';

class ContentView extends ConsumerWidget {
  const ContentView({Key? key}) : super(key: key);

  static final searchedContentProvider = StateProvider((ref) {
    final contentNotifier = ref.watch(contentHubProvider).contentNotifiers;
    final searchInput = ref.watch(SearchBox.searchProvider('content'));

    if (searchInput.isNotEmpty) {
      return contentNotifier
          .where((element) => element.title.toLowerCase().contains(searchInput))
          .toList();
    }

    return contentNotifier;
  });

  static final orderProvider = StateProvider((ref) => 'Norm');
  static final contentProvider = StateProvider<List<ContentNotifier>>(
    (ref) {
      final searchedContents = ref.watch(searchedContentProvider);
      final order = ref.watch(orderProvider);

      if (order == 'Last') {
        return searchedContents.toList()
          ..sort((a, b) => b.value.updatedAt.compareTo(a.value.updatedAt));
      }

      return searchedContents;
    },
  );

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        const ContentShortStatus(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
            child: Column(
              children: [
                _toolBar(context),
                const SearchBox(stateName: 'content'),
                Expanded(
                  child: contentListWidget(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _toolBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          const Text(
            'Contents',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),

          // filter list
          const ContentOrderButton(),
          // add item
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => addContentDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget contentListWidget(BuildContext context) => HookConsumer(
        builder: (context, ref, child) {
          final contentNotifiers = ref.watch(contentProvider);

          final scrollController = useScrollController();

          if (contentNotifiers.isEmpty) {
            return const Center(
              child: Text(
                'Empty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: contentNotifiers.length,
              itemBuilder: (context, index) {
                final contentNotifier = contentNotifiers[index];

                return ContentItem(contentNotifier);
              },
            ),
          );
        },
      );
}
