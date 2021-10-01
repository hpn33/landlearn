import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/dao/content_dao.dart';
import 'package:moor/moor.dart';

import 'dao/word_dao.dart';
import 'database/shared.dart';
import 'table/contents.dart';
import 'table/words.dart';

part 'database.g.dart';

final dbProvider = Provider((ref) => constructDb(logStatements: !kReleaseMode));

@UseMoor(
  tables: [Words, Contents],
  daos: [WordDao, ContentDao],
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // onCreate: (m) async {
        //  clearAllTable();
        // },
        onUpgrade: (m, from, to) async {
          // if (from == 1) {
          //   m.createTable(contents);
          // }
        },
        // beforeOpen: (details) async {
        // if (!details.wasCreated) {
        //   return;
        // }

        // if ((await select(scores).get()).isNotEmpty) {
        //   return;
        // }

        // for (final score in hiveW.scores.all) {
        //   await into(scores).insert(
        //     ScoresCompanion.insert(
        //       title: '1',
        //       score: score.score,
        //       createAt: Value(score.date),
        //     ),
        //   );
        // }
        // },
      );

  void clearAllTable() {
    final migrator = createMigrator();

    for (final table in allTables) {
      migrator.drop(table);
    }

    migrator.createAll();
  }
}
