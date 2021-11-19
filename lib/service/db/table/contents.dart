import 'package:moor/moor.dart';

class Contents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get data => text().withDefault(const Constant('{}'))();
}
