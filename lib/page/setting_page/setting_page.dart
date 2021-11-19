import 'package:flutter/material.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/logic/delete_all_database.dart';
import 'package:landlearn/service/logic/load_default_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                context.read(dbProvider),
                context.read(wordHubProvider),
                context.read(contentHubProvider),
              );
            },
          ),
          ListTile(
            title: Text('delete all'),
            onTap: () => deleteAllData(context),
          ),
        ],
      ),
    );
  }
}
