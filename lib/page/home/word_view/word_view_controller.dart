import 'package:hooks_riverpod/hooks_riverpod.dart';

final wordViewControllerProvider =
    Provider.autoDispose((ref) => WordViewController());

class WordViewController {}
