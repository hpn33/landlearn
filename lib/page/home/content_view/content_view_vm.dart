import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

// final contentViewVM = Provider.autoDispose((ref) => ContentViewVM());

// class ContentViewVM {
//   var contentLists;

//   void init() {}
// }

final contentsStreamProvider =
    StreamProvider((ref) => ref.read(dbProvider).contentDao.watching());

final contentsListProvider = StateProvider<List<Content>>(
  (ref) => ref.watch(contentsStreamProvider).when(
        data: (data) => data,
        loading: () => [],
        error: (s, o) => [],
      ),
);
