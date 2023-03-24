import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/util/delete_all_database.dart';
import 'package:landlearn/logic/util/load_default_data.dart';
import 'package:landlearn/logic/model/content_hub.dart';
import 'package:landlearn/logic/model/word_hub.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Default Content'),
            onTap: () {
              loadDefaultData(
                ref.read(dbProvider),
                ref.read(wordHubProvider),
                ref.read(contentHubProvider),
              );
            },
          ),
          ListTile(
            title: const Text('delete all'),
            onTap: () => deleteAllData(ref),
          ),
        ],
      ),
    );
  }
}
