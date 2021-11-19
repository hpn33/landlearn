import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
// import 'package:hive/hive.dart';
// import 'package:landlearn/hive/project.dart';
import 'package:landlearn/util/sample.dart';

Widget addContentDialog() {
  return Dialog(
    child: HookConsumer(
      builder: (context, ref, child) {
        final db = ref.read(dbProvider);

        final controller = useTextEditingController();
        final useSample = useState(false);

        return Container(
          width: 500,
          height: 300,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('content'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Hive.box<ProjectObj>('projects').add(
                      //   ProjectObj()
                      //     ..title = controller.text
                      //     ..text = useSample.value ? sample : '',
                      // );

                      db.contentDao.add(
                        controller.text,
                        useSample.value ? sample : '',
                      );

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              const Text('title'),
              TextField(controller: controller),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('use Sample'),
                  Checkbox(
                    value: useSample.value,
                    onChanged: (v) => useSample.value = v!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
