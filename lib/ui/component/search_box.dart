import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/util/screen_size.dart';

class SearchBox extends HookConsumerWidget {
  static final searchStateProvider = Provider((ref) => <String, String>{});
  static final searchProvider = StateProvider.family<String, String>(
    (ref, state) {
      final states = ref.read(searchStateProvider);

      if (!states.containsKey(state)) {
        states[state] = '';
      }

      return states[state]!;
    },
  );

  final String stateName;

  const SearchBox({required this.stateName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final searchController = useTextEditingController(
      text: ref.read(searchProvider(stateName)),
    );

    final isDesktop = screenSize(context).isCompactScreen;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                constraints: BoxConstraints(
                  minHeight: isDesktop ? 35 : 50,
                  maxHeight: isDesktop ? 35 : 50,
                ),
              ),
              onChanged: (value) {
                ref.read(searchProvider(stateName).notifier).state = value;
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
                        ref.read(searchProvider(stateName).notifier).state = '';
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
  }
}
