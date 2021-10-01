import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import '../database.dart';

Database constructDb({String fileName = 'numemo', bool logStatements = false}) {
  final fName = '$fileName.sqlite';

  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, fName));

      return VmDatabase(dbFile, logStatements: logStatements);
    });

    return Database(executor);
  }

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    final file = File(fName);
    return Database(VmDatabase(file, logStatements: logStatements));
  }

  // if (Platform.isWindows) {
  //   final file = File(fName);
  //   return Database(VmDatabase(file, logStatements: logStatements));
  // }

  return Database(VmDatabase.memory(logStatements: logStatements));
}
