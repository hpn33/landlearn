import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';

Widget addWordDialog() {
  return Dialog(
    child: HookConsumer(
      builder: (context, ref, child) {
        final controller = useTextEditingController();

        return Container(
          width: 500,
          height: 200,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('word'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final db = ref.read(dbProvider);
                      db.wordDao.add(controller.text);

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              TextField(controller: controller),
            ],
          ),
        );
      },
    ),
  );
}
