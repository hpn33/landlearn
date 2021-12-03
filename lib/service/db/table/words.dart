import 'package:moor/moor.dart';

class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()();
  BoolColumn get know => boolean()();
  TextColumn get note => text().nullable()();
  TextColumn get onlineTranslation => text().nullable()();
}
