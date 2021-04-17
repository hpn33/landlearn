import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:landlearn/hive/project.dart';

import 'app.dart';
import 'hive/project.dart';

void main() async {
  await loadHive();

  runApp(ProviderScope(child: MyApp()));
}

Future<void> loadHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProjectObjAdapter());

  await Hive.openBox('words')
    ..clear();
  await Hive.openBox('projects')
    ..clear();
}
