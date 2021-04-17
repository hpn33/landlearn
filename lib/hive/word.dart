import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class WordObj extends HiveObject {
  @HiveField(0)
  late String word;

  @HiveField(1)
  bool know = false;
}
