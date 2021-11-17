import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:landlearn/service/logic/delete_all_database.dart';

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
                onPressed: () => deleteAllData(context),
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
