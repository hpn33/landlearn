import 'package:drift/web.dart';

import '../database.dart';

Database constructDb({
  String? subPath,
  String fileName = 'db',
  bool logStatements = false,
}) {
  return Database(WebDatabase(fileName, logStatements: logStatements));
}
