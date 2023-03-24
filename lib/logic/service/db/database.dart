import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dao/content_dao.dart';
import 'dao/word_dao.dart';
import 'database/shared.dart';
import 'table/contents.dart';
import 'table/words.dart';

part 'database.g.dart';

final dbProvider = Provider(
  (ref) => constructDb(
    subPath: 'LandLearn',
    fileName: 'landLearn',
    logStatements: !kReleaseMode,
  ),
);

@DriftDatabase(
  tables: [Words, Contents],
  daos: [WordDao, ContentDao],
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 4;

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

          if (newFrom == 2) {
            await m.addColumn(words, words.note);
            await m.addColumn(words, words.onlineTranslation);

            newFrom = 3;
          }

          if (newFrom == 3) {
            await m.addColumn(words, words.createdAt);
            await m.addColumn(words, words.updatedAt);

            await m.addColumn(contents, contents.createdAt);
            await m.addColumn(contents, contents.updatedAt);

            newFrom = 4;
          }
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
