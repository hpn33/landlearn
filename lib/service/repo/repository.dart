import 'package:flutter/material.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Repository {
  final contents = RepoContent();
}

class RepoContent {
  Future<bool> updateContent(
      BuildContext context, ContentData contentO, String text) async {
    final db = context.read(dbProvider);

    return await db.contentDao.updateContent(contentO.content, text);
  }
}
