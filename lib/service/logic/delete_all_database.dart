import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';

void deleteAllData(WidgetRef ref) async {
  ref.read(dbProvider).resetAllTable();
  ref.read(contentHubProvider).clear();
  ref.read(wordHubProvider).clear();
}
