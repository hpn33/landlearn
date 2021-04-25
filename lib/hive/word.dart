import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 1)
class WordObj extends HiveObject {
  @HiveField(0)
  late String word;

  @HiveField(1)
  String translate = '';

  @HiveField(2)
  bool know = false;
}
