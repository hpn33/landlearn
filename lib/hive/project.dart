import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class ProjectObj extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String text;
}
