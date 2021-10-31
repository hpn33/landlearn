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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // onCreate: (m) async {
        //  clearAllTable();
        // },
        onUpgrade: (m, from, to) async {
          var newFrom = from;

          if (newFrom == 1) {
            await m.addColumn(contents, contents.data);
            newFrom = 2;
          }

          // if (newFrom == 2) {

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

  void resetAllTable() {
    // final migrator = createMigrator();

// uture<void> deleteEverything() {
    // return
    transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
    // }
    // for (final table in allTables) {
    //   migrator.drop(table);
    // }

    // migrator.createAll();
  }
}
