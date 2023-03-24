import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/util/screen_size.dart';
import 'package:landlearn/ui/page/study/logic/study_controller.dart';

import 'component/content_text.dart';
import 'component/content_words.dart';
import 'logic/view_mode.dart';
import 'study.dart';

class StudyMobilePage extends HookConsumerWidget {
  // int viewPageIndex = 0;

  const StudyMobilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final pageController = usePageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.read(studyVMProvider).selectedContent.title),
        actions: [
          // toggle icon for view mode
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final viewMode = ref.watch(StudyPage.viewModeProvider);

              return IconButton(
                icon: viewMode == ViewMode.normal
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(Icons.thumb_down_alt_outlined),
                onPressed: () {
                  ref.read(StudyPage.viewModeProvider.notifier).state =
                      viewMode == ViewMode.normal
                          ? ViewMode.unknow
                          : ViewMode.normal;
                },
              );
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              // change between content view and word view
              PopupMenuItem(
                value: 'pageIndex',
                child: Text(pageController.page == 0.0
                    ? 'Show Words View'
                    : 'Show Content View'),
                onTap: () {
                  pageController.jumpToPage(pageController.page == 0.0 ? 1 : 0);
                },
              ),
              // change mode between study and review
              PopupMenuItem(
                value: ref.read(StudyPage.viewModeProvider).toString(),
                child: Text(
                  ref.read(StudyPage.viewModeProvider) == ViewMode.normal
                      ? 'Show Level'
                      : 'Hide Level',
                ),
                onTap: () {
                  ref.read(StudyPage.viewModeProvider.notifier).state =
                      ref.read(StudyPage.viewModeProvider) == ViewMode.normal
                          ? ViewMode.unknow
                          : ViewMode.normal;
                },
              ),
              // toggle subtitle
              CheckedPopupMenuItem(
                value: 'subtitle',
                checked: ref.read(StudyPage.showSubtitleProvider),
                child: const Text('Subtitle'),
              ),
            ],
            onSelected: (selectedIndex) {
              if (selectedIndex == 'subtitle') {
                ref.read(StudyPage.showSubtitleProvider.notifier).state =
                    !ref.read(StudyPage.showSubtitleProvider);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: screenSize(context).isMediumScreen
                    ? screenSize(context).isExpandedScreen
                        ? 1140
                        : MediaQuery.of(context).size.width * 0.8
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SideBar(),
                    // Expanded(child: ContentTextWidget()),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        children: const [
                          ContentTextWidget(),
                          ContentWordWidget(),
                        ],
                      ),
                    ),
                    // ContentWordToggleWidget(),
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
