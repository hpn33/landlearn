import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:landlearn/hive/project.dart';
import 'package:landlearn/util/sample.dart';

Widget addContentDialog() {
  return Dialog(
    child: HookBuilder(
      builder: (BuildContext context) {
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
                  Text('content'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Hive.box<ProjectObj>('projects').add(
                        ProjectObj()
                          ..title = controller.text
                          ..text = useSample.value ? sample : '',
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Divider(),
              Text('title'),
              TextField(controller: controller),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('use Sample'),
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
