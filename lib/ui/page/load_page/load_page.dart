import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/util/load_default_data.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/word_hub.dart';
import 'package:landlearn/ui/page/home/home.dart';

class LoadPage extends HookConsumerWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useEffect(() {
      Future.wait([load(ref)]).then(
        (value) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const HomePage()),
          );
        },
      );

      return null;
    }, []);

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

    if (Hive.box('configs').get('first_time')) {
      await loadDefaultData(db, wordHub, contentHub);

      await Hive.box('configs').put('first_time', false);
    }
  }

  Future<void> loadData(
    Database db,
    WordHub wordHub,
    ContentHub contentHub,
  ) async {
    // db.wordDao.getAll().then((words) {
    //   wordHub.load(words);

    //   db.contentDao
    //       .getAll()
    //       .then((contents) => contentHub.load(wordHub, contents));
    // });

    final words = await db.wordDao.getAll();
    await wordHub.load(words);

    final contents = await db.contentDao.getAll();
    await contentHub.load(wordHub, contents);

    await Future.delayed(const Duration(milliseconds: 100));
  }
}
