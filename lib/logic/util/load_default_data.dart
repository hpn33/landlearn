import 'package:flutter/services.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/word_hub.dart';

import 'analyze_content.dart';

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

Future<void> loadDefaultData(
  Database db,
  WordHub wordHub,
  ContentHub contentHub,
) async {
  final newContent = <Content>[];

  // insert new content
  for (final fileTitle in materials) {
    final matchContent = contentHub.contents.where((c) => c.title == fileTitle);
    if (matchContent.isNotEmpty) {
      continue;
    }

    final assets =
        await rootBundle.loadString('assets/material/$fileTitle.txt');

    newContent.add(await db.contentDao.add(fileTitle, assets));
  }

  if (newContent.isEmpty) {
    return;
  }

  // load
  final analyzeList = contentHub.addLoad(wordHub, newContent);

  // analyze
  for (final contentNotifier in analyzeList) {
    await analyzeContent(db, contentNotifier, wordHub);
    contentHub.notify();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
