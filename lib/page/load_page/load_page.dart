import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:landlearn/page/home/home.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/load_default_data.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.wait([load(context)]).then(
      (value) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => HomePage()),
        );
      },
    );

    return Material(
      child: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> load(BuildContext context) async {
    await loadData(context);

    if (Hive.box('configs').get('first_time')) {
      await loadDefaultData(
        context.read(dbProvider),
        context.read(wordHubProvider),
        context.read(contentHubProvider),
      );

      await Hive.box('configs').put('first_time', false);
    }
  }

  Future<void> loadData(BuildContext context) async {
    final db = context.read(dbProvider);
    final wordHub = context.read(wordHubProvider);
    final contentHub = context.read(contentHubProvider);

    final words = await db.wordDao.getAll();
    wordHub.load(words);

    final contents = await db.contentDao.getAll();
    contentHub.load(wordHub, contents);

    await Future.delayed(Duration(milliseconds: 100));
  }
}
