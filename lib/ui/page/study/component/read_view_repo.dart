import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/model/word_notifier.dart';
import 'package:translator/translator.dart';

final translate = FutureProvider.family<Translation, WordNotifier>(
  (ref, wordNotifier) async =>
      wordNotifier.word.translate(from: 'en', to: 'fa'),
);

final repoTranslate = FutureProvider.family<String, WordNotifier>(
  (ref, wordNotifier) async {
    if (wordNotifier.onlineTranslation != null) {
      return Future.value(wordNotifier.value.onlineTranslation!);
    }

    final translation = await ref.watch(translate(wordNotifier).future);

    final db = ref.read(dbProvider);

    wordNotifier.updateOnlineTranslation(translation.toString());
    await db.wordDao.up(wordNotifier.value);

    return translation.toString();
  },
);
