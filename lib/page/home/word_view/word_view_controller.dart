import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

final getAllWordsFutureProvider =
    FutureProvider((ref) => ref.read(dbProvider).wordDao.getAll());

final getAllWordsStateProvider = StateProvider<List<Word>>(
  (ref) => ref.watch(getAllWordsFutureProvider).when(
        data: (data) => data,
        loading: () => [],
        error: (s, o) => [],
      ),
);
