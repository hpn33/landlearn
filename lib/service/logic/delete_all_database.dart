import 'package:flutter/cupertino.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void deleteAllData(BuildContext context) async {
  context.read(dbProvider).resetAllTable();
  context.read(contentHubProvider).clear();
  context.read(wordHubProvider).clear();
}
