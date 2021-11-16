import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:landlearn/service/logic/analyze_content.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';

const materials = [
  'Eureka Eureka',
  'Fair Shares',
  'Good Company and Bad Company',
  'Hercules',
  'Louis Pasteur',
  'Reward for bravery',
  'The Death of A Man Eater',
  'The Story of The Prodigal Son',
  'The Three Questions',
  'Three Simple Rules',
  'Yussouf',
];

Future<void> loadDefaultData(BuildContext context) async {
  final db = context.read(dbProvider);
  final wordHub = context.read(wordHubProvider);

  // insert new content
  for (final fileTitle in materials) {
    final assets =
        await rootBundle.loadString('assets/material/$fileTitle.txt');

    await db.contentDao.add(fileTitle, assets);
  }

  // load
  final contents = await db.contentDao.getAll();
  final contentHub = context.read(contentHubProvider)..load(wordHub, contents);

  // analyze
  for (final contentNotifier in contentHub.contentNotifiers) {
    await analyzeContent(db, contentNotifier, wordHub);
    await Future.delayed(Duration(milliseconds: 1000));
    contentHub.notify();
  }
}
