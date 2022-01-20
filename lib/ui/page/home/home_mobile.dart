import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/util/util.dart';

import 'content_view/content_view.dart';
import 'word_view/word_view.dart';

class MobileHomePage extends HookConsumerWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  static final pageIndexProvider = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context, ref) {
    final pageIndex = ref.read(pageIndexProvider.state);

    final pageController = usePageController(initialPage: pageIndex.state);
    useListenable(pageController);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: PageView(
        controller: pageController,
        children: const [
          // pageScroll(
          // const
          ContentView(),
          //  0, 2, pageController),
          // pageScroll(
          // const
          WordView(),
          //  1, 2, pageController),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Contents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Words',
          ),
        ],
        currentIndex: pageIndex.state,
        // pageController.positions.isEmpty ? 0 : pageController.page!.toInt(),
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          pageIndex.state = index;
          pageController.jumpToPage(index);
        },
      ),
    );
  }

  Widget pageScroll(
    Widget child,
    int index,
    int lenght,
    PageController pageController,
  ) {
    if (Platform.isAndroid) {
      return child;
    }

    return Row(
      children: [
        if (index > 0)
          TextButton(
            child: const Text('<'),
            onPressed: () {
              pageController.animateToPage(
                index - 1,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
              );
            },
          ),
        Expanded(child: child),
        if (index < lenght - 1)
          TextButton(
            child: const Text('>'),
            onPressed: () {
              pageController.animateToPage(
                index + 1,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
              );
            },
          ),
      ],
    );
  }
}
