import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:landlearn/page/home/content_view.dart';
import 'package:landlearn/page/home/word_view.dart';

class MobileHomePage extends HookWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    useListenable(pageController);

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          pageScroll(WordView(), 0, 2, pageController),
          pageScroll(ContentView(), 1, 2, pageController),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'کلمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'متن ها',
          ),
        ],
        currentIndex:
            pageController.positions.isEmpty ? 0 : pageController.page!.toInt(),
        selectedItemColor: Colors.amber[800],
        onTap: (index) => pageController.jumpToPage(index),
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
            child: Text('<'),
            onPressed: () {
              pageController.animateToPage(
                index - 1,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500),
              );
            },
          ),
        Expanded(child: child),
        if (index < lenght - 1)
          TextButton(
            child: Text('>'),
            onPressed: () {
              pageController.animateToPage(
                index + 1,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500),
              );
            },
          ),
      ],
    );
  }
}
