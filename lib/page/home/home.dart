import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:landlearn/page/setting_page/setting_page.dart';
import 'package:landlearn/util/util.dart';

import 'home_desk.dart';
import 'home_mobile.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          _appbar(context),
          Expanded(child: getChild(context)),
        ],
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return Container(
      color: const Color(0xff5c728A),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getChild(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return const MobileHomePage();
    }

    return const DeskHomePage();
  }
}
