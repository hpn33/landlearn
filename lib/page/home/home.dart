import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';

import 'desk.dart';
import 'mobile.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                child: Text('delete all'),
                onPressed: () {
                  context.read(dbProvider).resetAllTable();
                  context.read(contentHubProvider).clear();
                  context.read(wordHubProvider).clear();
                },
              )
            ],
          ),
          Expanded(child: getChild(context)),
        ],
      ),
    );
  }

  Widget getChild(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return MobileHomePage();
    }

    return DeskHomePage();
  }
}
