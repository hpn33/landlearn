import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/analyze_content.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_hub.dart';

final selectedContentProvider = StateProvider<ContentNotifier?>((ref) => null);

final textControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  final contentNotifier = ref.watch(selectedContentProvider);

  return TextEditingController(
    text: contentNotifier == null ? 'something Wrong' : contentNotifier.content,
  );
});

/// logic

/// extract work from content text
Future<void> analyze(WidgetRef ref) async {
  final contentNotifier = ref.read(selectedContentProvider)!;
  final wordHub = ref.read(wordHubProvider);
  final db = ref.read(dbProvider);

  analyzeContent(db, contentNotifier, wordHub);
}
