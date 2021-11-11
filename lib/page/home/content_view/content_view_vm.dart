import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';

final watchContentsProvider =
    StreamProvider((ref) => ref.read(dbProvider).contentDao.watching());

final getContentNotifiersStateProvider = StateProvider<List<ContentNotifier>>(
  (ref) => ref.watch(watchContentsProvider).when(
        data: (data) => data.map((e) => ContentNotifier(e)).toList(),
        loading: () => [],
        error: (s, o) => [],
      ),
);
