import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  await loadHive();

  runApp(ProviderScope(
    child: MyApp(),
    // observers: [Ob()],
  ));
}

Future<void> loadHive() async {
  await Hive.initFlutter('landlearn');

  final box = await Hive.openBox('configs');

  await box.put('first_time', true);
}

class Ob extends ProviderObserver {
  void didAddProvider(ProviderBase provider, Object? value) {
    print('didAddProvider: $provider');
    // print('didAddProvider: $provider :: $value');
  }

  void mayHaveChanged(ProviderBase provider) {
    print('mayHaveChanged: $provider');
  }

  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    print('didUpdateProvider: $provider');
    // print('didUpdateProvider: $provider :: $newValue');
  }

  void didDisposeProvider(ProviderBase provider) {
    print('didDisposeProvider: $provider');
  }
}
