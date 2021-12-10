import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/logic/view_mode.dart';

import '../study.dart';

const viewModeItems = [
  Tooltip(message: 'Normal', child: Icon(Icons.remove_red_eye_outlined)),
  Tooltip(message: 'Know', child: Icon(Icons.thumb_up_alt_outlined)),
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
