import 'package:flutter/material.dart';
import 'package:landlearn/page/home/home.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.wait([loadData(context)]).then(
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

  Future<void> loadData(BuildContext context) async {
    final db = context.read(dbProvider);
    final wordHub = context.read(wordHubProvider);
    final contentHub = context.read(contentHubProvider);

    final words = await db.wordDao.getAll();
    wordHub.load(words);

    final contents = await db.contentDao.getAll();
    contentHub.load(wordHub, contents);

    await Future.delayed(Duration(seconds: 1));
  }
}
