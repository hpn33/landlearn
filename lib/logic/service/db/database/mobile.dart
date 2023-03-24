import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import '../database.dart';

Database constructDb({
  String? subPath,
  String fileName = 'db',
  bool logStatements = false,
}) {
  final fName = '$fileName.sqlite';

  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();

      final pas = subPath != null
          ? p.join(dataDir.path, subPath, fName)
          : p.join(dataDir.path, fName);

      final dbFile = File(pas);

      return NativeDatabase(dbFile, logStatements: logStatements);
    });

    return Database(executor);
  }

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();

      final pas = subPath != null
          ? p.join(dataDir.path, subPath, fName)
          : p.join(dataDir.path, fName);

      final dbFile = File(pas);

      return NativeDatabase(dbFile, logStatements: logStatements);
    });

    return Database(executor);

    // final file = File(fName);
    // return Database(VmDatabase(file, logStatements: logStatements));
  }

  return Database(NativeDatabase.memory(logStatements: logStatements));
}
