import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/home.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/load_default_data.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/util/util.dart';

class LoadPage extends HookConsumerWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Future.wait([load(ref)]).then(
      (value) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const HomePage()),
        );
      },
    );

    return const Material(
      child: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> load(WidgetRef ref) async {
    final db = ref.read(dbProvider);
    final wordHub = ref.read(wordHubProvider);
    final contentHub = ref.read(contentHubProvider);

    await loadData(db, wordHub, contentHub);

    if (Hive.box('configs').get('first_time_$versionString')) {
      await loadDefaultData(db, wordHub, contentHub);

      await Hive.box('configs').put('first_time$versionString', false);
    }
  }

  Future<void> loadData(
    Database db,
    WordHub wordHub,
    ContentHub contentHub,
  ) async {
    final words = await db.wordDao.getAll();
    wordHub.load(words);

    final contents = await db.contentDao.getAll();
    contentHub.load(wordHub, contents);

    await Future.delayed(const Duration(milliseconds: 100));
  }
}
