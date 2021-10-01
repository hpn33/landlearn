import 'package:landlearn/service/db/table/contents.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'content_dao.g.dart';

@UseDao(tables: [Contents])
class ContentDao extends DatabaseAccessor<Database> with _$ContentDaoMixin {
  final Database db;

  // Called by the AppDatabase class
  ContentDao(this.db) : super(db);

  Stream<List<Content>> watching() => select(contents).watch();

  Future<int> add(String title, String content) => into(contents).insert(
        ContentsCompanion.insert(title: title, content: content),
      );
}
