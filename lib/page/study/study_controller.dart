import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

import 'models/content_notifier.dart';

final selectedContentIdProvider = StateProvider<int>((ref) => -1);

final _getContentStreamProvider = FutureProvider.autoDispose<Content?>((ref) {
  final db = ref.read(dbProvider);
  final selectedContent = ref.watch(selectedContentIdProvider).state;

  return db.contentDao.getSingleBy(id: selectedContent);
});

final getContentNotifierProvider = StateProvider.autoDispose<ContentNotifier?>(
  (ref) => ref.watch(_getContentStreamProvider).when(
        data: (data) {
          final contentNotifier = data == null ? null : ContentNotifier(data);

          if (contentNotifier != null) {
            contentNotifier.getWordsFromDB(ref.read(dbProvider));
          }

          return contentNotifier;
        },
        loading: () => null,
        error: (s, o) => null,
      ),
);

final textControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  final contentNotifier = ref.watch(getContentNotifierProvider).state;

  return TextEditingController(
    text: contentNotifier == null ? 'something Wrong' : contentNotifier.content,
  );
});
