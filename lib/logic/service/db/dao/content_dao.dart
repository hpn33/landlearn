import 'package:landlearn/logic/service/db/table/contents.dart';
import 'package:landlearn/logic/model/content_notifier.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'content_dao.g.dart';

@UseDao(tables: [Contents])
class ContentDao extends DatabaseAccessor<Database> with _$ContentDaoMixin {
  final Database db;

  // Called by the AppDatabase class
  ContentDao(this.db) : super(db);

  Stream<List<Content>> watching() => select(contents).watch();

  Stream<Content?> watchingSingleBy({required int id}) =>
      (select(contents)..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();

  Future<Content> add(String title, String content) =>
      into(contents).insertReturning(
        ContentsCompanion.insert(title: title, content: content),
      );

  Future<void> up(Content content, [DateTime? updatedAt]) => update(contents)
      .replace(content.copyWith(updatedAt: updatedAt ?? DateTime.now()));

  Future<Content?> getSingleBy({required int id}) {
    return (select(contents)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Content>> getAll() => select(contents).get();

  Future<int> remove(ContentNotifier contentNotifier) =>
      delete(contents).delete(contentNotifier.value);
}
