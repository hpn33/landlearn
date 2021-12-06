import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_notifier.dart';

final selectedWordNotifierProvider =
    StateProvider<WordNotifier?>((ref) => null);
