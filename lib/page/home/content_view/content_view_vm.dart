import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';

final contentsStreamProvider =
    StreamProvider((ref) => ref.read(dbProvider).contentDao.watching());

final contentDatasListProvider = StateProvider<List<ContentData>>(
  (ref) => ref.watch(contentsStreamProvider).when(
        data: (data) => data.map((e) => ContentData(e)).toList(),
        loading: () => [],
        error: (s, o) => [],
      ),
);

// final getWordInStreamProvider = StreamProvider.family<List<Word>, List<int>>(
//   (ref, ids) => ref.read(dbProvider).wordDao.watchingIn(wordIds: ids),
// );

// final awarnessPercentProvider =
//     StateProvider.family<double, List<int>>((ref, ids) {
//   // print(ids);
//   final words = ref.watch(getWordInStreamProvider(ids));

//   return words.when(
//     data: (data) {
//       // print(data);
//       return (data.where((element) => element.know).length / data.length) * 100;
//     },
//     loading: () => 0.0,
//     error: (s, o) => 0.0,
//   );
// });
