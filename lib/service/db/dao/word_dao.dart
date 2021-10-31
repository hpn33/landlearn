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

  Future<Word> add(String word) => into(words)
      .insertReturning(WordsCompanion.insert(word: word, know: false));

  Future<bool> updating(Word word) => (update(words).replace(word));

  Stream<List<Word>> watchingIn({required Iterable<int> wordIds}) =>
      (select(words)..where((tbl) => tbl.id.isIn(wordIds))).watch();
}
