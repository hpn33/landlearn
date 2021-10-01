import 'package:landlearn/service/db/table/words.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'word_dao.g.dart';

@UseDao(tables: [Words])
class WordDao extends DatabaseAccessor<Database> with _$WordDaoMixin {
  final Database db;

  // Called by the AppDatabase class
  WordDao(this.db) : super(db);

  Stream<List<Word>> watching() => select(words).watch();
  Future<List<Word>> getAll() => select(words).get();

  Future<int> add(String word) =>
      into(words).insert(WordsCompanion.insert(word: word, know: false));
}
