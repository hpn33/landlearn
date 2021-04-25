import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:landlearn/hive/project.dart';

import 'app.dart';
import 'hive/project.dart';
import 'hive/word.dart';

void main() async {
  await loadHive();

  runApp(ProviderScope(child: MyApp()));
}

Future<void> loadHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProjectObjAdapter());
  Hive.registerAdapter(WordObjAdapter());

  await Hive.openBox<WordObj>('words');
  await Hive.openBox<ProjectObj>('projects');
}
