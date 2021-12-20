import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/word_hub.dart';

void deleteAllData(WidgetRef ref) async {
  ref.read(dbProvider).resetAllTable();
  ref.read(contentHubProvider).clear();
  ref.read(wordHubProvider).clear();
}
