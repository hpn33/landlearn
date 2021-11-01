import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';

void main() async {
  runApp(ProviderScope(
    child: MyApp(),
    observers: [Ob()],
  ));
}

class Ob extends ProviderObserver {
  void didAddProvider(ProviderBase provider, Object? value) {
    print('didAddProvider: $provider :: $value');
  }

  void mayHaveChanged(ProviderBase provider) {
    print('mayHaveChanged: $provider');
  }

  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    print('didUpdateProvider: $provider :: $newValue');
  }

  void didDisposeProvider(ProviderBase provider) {
    print('didDisposeProvider: $provider');
  }
}
