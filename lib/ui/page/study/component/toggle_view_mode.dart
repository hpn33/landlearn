import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/ui/page/study/logic/view_mode.dart';

import '../study.dart';

const viewModeItems = [
  Tooltip(message: 'Read Only', child: Icon(Icons.remove_red_eye_outlined)),
  Tooltip(message: 'Unknow', child: Icon(Icons.thumb_down_alt_outlined)),
];

class ToggleViewModeButton extends StatelessWidget {
  const ToggleViewModeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Views '),
        HookConsumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final viewMode = ref.watch(StudyPage.viewModeProvider.state);

            final isSelected = useState(<bool>[]);

            useEffect(
              () {
                final index = ViewMode.values.indexOf(viewMode.state);
                isSelected.value =
                    List.generate(viewModeItems.length, (i) => i == index);

                return null;
              },
              [viewMode.state],
            );

            return ToggleButtons(
              children: viewModeItems,
              onPressed: (int index) async {
                isSelected.value =
                    List.generate(viewModeItems.length, (i) => index == i);

                viewMode.state = ViewMode.values[index];
              },
              isSelected: isSelected.value,
            );
          },
        ),
        const SizedBox(width: 6),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return Tooltip(
              message: 'Edit',
              child: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () {
                  ref.read(StudyPage.viewModeProvider.state).state =
                      ViewMode.edit;
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class ToggleViewModeButton2 extends StatelessWidget {
  const ToggleViewModeButton2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          const Text(
            'Modes',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          toggleWidget(),
          const SizedBox(height: 5),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return Tooltip(
                message: 'Edit',
                child: FloatingActionButton(
                  child: const Icon(Icons.edit),
                  onPressed: () {
                    ref.read(StudyPage.viewModeProvider.state).state =
                        ViewMode.edit;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget toggleWidget() => HookConsumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final viewMode = ref.watch(StudyPage.viewModeProvider.state);

          final isSelected = useState(<bool>[]);

          useEffect(
            () {
              final index = ViewMode.values.indexOf(viewMode.state);
              isSelected.value =
                  List.generate(viewModeItems.length, (i) => i == index);

              return null;
            },
            [viewMode.state],
          );

          // return Container(
          //   color: Colors.grey[200],
          //   child: Column(
          //     children: [],
          //   ),
          // );

          return ToggleButtons(
            borderRadius: BorderRadius.circular(24),
            direction: Axis.vertical,
            children: viewModeItems,
            onPressed: (int index) async {
              isSelected.value =
                  List.generate(viewModeItems.length, (i) => index == i);

              viewMode.state = ViewMode.values[index];
            },
            isSelected: isSelected.value,
          );
        },
      );
}
