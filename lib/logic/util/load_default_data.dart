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

const enTop100 = [
  'enTop100',
  't100 1',
  't100 2',
  't100 The Lost Locket',
  't100 The Missing Key',
];

const w504 = [
  '504-001-050',
  '504',
  '504-Emily',
];

Future<void> loadDefaultData(
  Database db,
  WordHub wordHub,
  ContentHub contentHub,
) async {
  final newContent = <Content>[];

  // insert new content
  await loadFiles("assets/en/material/", materials, contentHub, newContent, db);
  await loadFiles("assets/en/t100/", enTop100, contentHub, newContent, db);
  await loadFiles("assets/en/504/", w504, contentHub, newContent, db);

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

Future<void> loadFiles(String path, List<String> fileList,
    ContentHub contentHub, List<Content> newContent, Database db) async {
  for (final fileTitle in fileList) {
    final matchContent = contentHub.contents.where((c) => c.title == fileTitle);
    if (matchContent.isNotEmpty) {
      continue;
    }

    final assets = await rootBundle.loadString('$path$fileTitle.txt');

    newContent.add(await db.contentDao.add(fileTitle, assets));
  }
}
