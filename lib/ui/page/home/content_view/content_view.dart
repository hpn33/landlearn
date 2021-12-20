import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:landlearn/ui/page/dialog/add_content_dialog.dart';

import 'content_item.dart';

class ContentView extends StatelessWidget {
  const ContentView({Key? key}) : super(key: key);

  static final searchProvider = StateProvider((ref) => '');
  static final searchedContentProvider = StateProvider((ref) {
    final contentNotifier = ref.watch(contentHubProvider).contentNotifiers;
    final searchInput = ref.watch(searchProvider);

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          _toolBar(context),
          _order(),
          _search(),
          Expanded(
            child: contentListWidget(context),
          ),
        ],
      ),
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

  Widget _order() {
    return HookConsumer(builder: (context, ref, child) {
      final order = ref.watch(orderProvider);

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Order'),
              const Spacer(),
              TextButton(
                child: const Text('Norm'),
                onPressed: order == 'Norm'
                    ? null
                    : () => ref.read(orderProvider.state).state = 'Norm',
              ),
              TextButton(
                child: const Text('Last'),
                onPressed: order == 'Last'
                    ? null
                    : () => ref.read(orderProvider.state).state = 'Last',
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _search() => HookConsumer(
        builder: (context, ref, child) {
          final searchController =
              useTextEditingController(text: ref.read(searchProvider));

          return Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      ref.read(searchProvider.state).state = value;
                    },
                  ),
                ),
                HookBuilder(
                  builder: (context) {
                    useListenable(searchController);

                    return Row(
                      children: [
                        if (searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              ref.read(searchProvider.state).state = '';
                            },
                          ),
                        if (searchController.text.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.search),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

  Widget contentListWidget(BuildContext context) => HookConsumer(
        builder: (context, ref, child) {
          final contentNotifiers = ref.watch(contentProvider);

          final scrollController = useScrollController();

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
