import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:landlearn/logic/util/util.dart';
import 'package:landlearn/logic/util/window_size.dart';
import 'package:landlearn/ui/component/app_info_panel.dart';
import 'package:landlearn/ui/page/setting_page/setting_page.dart';

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

          // info icon button
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AppInfoDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getChild(BuildContext context) {
    final isCompactScreen = MediaQuery.of(context).isCompactScreen;

    if (isCompactScreen) {
      return const MobileHomePage();
    }

    return const DeskHomePage();
  }
}
