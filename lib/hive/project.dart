import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class ProjectObj extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;
}
