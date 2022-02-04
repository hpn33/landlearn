import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'component/content_text.dart';
import 'component/content_words.dart';
import 'component/side_bar.dart';

class StudyDesktopPage extends HookConsumerWidget {
  const StudyDesktopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 950
                    ? MediaQuery.of(context).size.width > 1140
                        ? 1140
                        : MediaQuery.of(context).size.width * 0.8
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SideBar(),
                    Expanded(child: ContentTextWidget()),
                    ContentWordToggleWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
