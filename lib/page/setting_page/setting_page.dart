import 'package:flutter/material.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/delete_all_database.dart';
import 'package:landlearn/service/logic/load_default_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';

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
            title: Text('Add Default Content'),
            onTap: () {
              loadDefaultData(
                ref.read(dbProvider),
                ref.read(wordHubProvider),
                ref.read(contentHubProvider),
              );
            },
          ),
          ListTile(
            title: Text('delete all'),
            onTap: () => deleteAllData(ref),
          ),
        ],
      ),
    );
  }
}
