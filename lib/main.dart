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
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
