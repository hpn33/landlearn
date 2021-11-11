import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/word_hub.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';

final watchContentsProvider =
    StreamProvider((ref) => ref.read(dbProvider).contentDao.watching());

final getContentNotifiersStateProvider = StateProvider<List<ContentNotifier>>(
  (ref) {
    final wordHub = ref.watch(wordHubProvider);

    return ref.watch(watchContentsProvider).when(
          data: (data) {
            final contentNotifiers =
                data.map((e) => ContentNotifier(e)).toList();

            contentNotifiers.forEach((element) => element.loadData(wordHub));

            return contentNotifiers;
          },
          loading: () => [],
          error: (s, o) => [],
        );
  },
);
