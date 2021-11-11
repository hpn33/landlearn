import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_notifier.dart';

final selectedContentStateProvider =
    StateProvider<ContentNotifier?>((ref) => null);

final textControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  final contentNotifier = ref.watch(selectedContentStateProvider).state;

  return TextEditingController(
    text: contentNotifier == null ? 'something Wrong' : contentNotifier.content,
  );
});
