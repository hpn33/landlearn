import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/home.dart';
import 'package:landlearn/page/hub_provider.dart';

class LoadPage extends HookWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hub = useProvider(hubProvider);

    Future.wait([hub.init()]).then((value) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
    });

    return Material(
      child: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
