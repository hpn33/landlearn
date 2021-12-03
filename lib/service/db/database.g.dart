// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Word extends DataClass implements Insertable<Word> {
  final int id;
  final String word;
  final bool know;
  final String? note;
  final String? onlineTranslation;
  Word(
      {required this.id,
      required this.word,
      required this.know,
      this.note,
      this.onlineTranslation});
  factory Word.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Word(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      word: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}word'])!,
      know: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}know'])!,
      note: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}note']),
      onlineTranslation: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}online_translation']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    map['know'] = Variable<bool>(know);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String?>(note);
    }
    if (!nullToAbsent || onlineTranslation != null) {
      map['online_translation'] = Variable<String?>(onlineTranslation);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      word: Value(word),
      know: Value(know),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      onlineTranslation: onlineTranslation == null && nullToAbsent
          ? const Value.absent()
          : Value(onlineTranslation),
    );
  }

  factory Word.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      know: serializer.fromJson<bool>(json['know']),
      note: serializer.fromJson<String?>(json['note']),
      onlineTranslation:
          serializer.fromJson<String?>(json['onlineTranslation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'know': serializer.toJson<bool>(know),
      'note': serializer.toJson<String?>(note),
      'onlineTranslation': serializer.toJson<String?>(onlineTranslation),
    };
  }

  Word copyWith(
          {int? id,
          String? word,
          bool? know,
          String? note,
          String? onlineTranslation}) =>
      Word(
        id: id ?? this.id,
        word: word ?? this.word,
        know: know ?? this.know,
        note: note ?? this.note,
        onlineTranslation: onlineTranslation ?? this.onlineTranslation,
      );
  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('know: $know, ')
          ..write('note: $note, ')
          ..write('onlineTranslation: $onlineTranslation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, know, note, onlineTranslation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.word == this.word &&
          other.know == this.know &&
          other.note == this.note &&
          other.onlineTranslation == this.onlineTranslation);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> word;
  final Value<bool> know;
  final Value<String?> note;
  final Value<String?> onlineTranslation;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.know = const Value.absent(),
    this.note = const Value.absent(),
    this.onlineTranslation = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required bool know,
    this.note = const Value.absent(),
    this.onlineTranslation = const Value.absent(),
  })  : word = Value(word),
        know = Value(know);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<bool>? know,
    Expression<String?>? note,
    Expression<String?>? onlineTranslation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (know != null) 'know': know,
      if (note != null) 'note': note,
      if (onlineTranslation != null) 'online_translation': onlineTranslation,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? word,
      Value<bool>? know,
      Value<String?>? note,
      Value<String?>? onlineTranslation}) {
    return WordsCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      know: know ?? this.know,
      note: note ?? this.note,
      onlineTranslation: onlineTranslation ?? this.onlineTranslation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (know.present) {
      map['know'] = Variable<bool>(know.value);
    }
    if (note.present) {
      map['note'] = Variable<String?>(note.value);
    }
    if (onlineTranslation.present) {
      map['online_translation'] = Variable<String?>(onlineTranslation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('know: $know, ')
          ..write('note: $note, ')
          ..write('onlineTranslation: $onlineTranslation')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WordsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _wordMeta = const VerificationMeta('word');
  late final GeneratedColumn<String?> word = GeneratedColumn<String?>(
      'word', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _knowMeta = const VerificationMeta('know');
  late final GeneratedColumn<bool?> know = GeneratedColumn<bool?>(
      'know', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (know IN (0, 1))');
  final VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String?> note = GeneratedColumn<String?>(
      'note', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _onlineTranslationMeta =
      const VerificationMeta('onlineTranslation');
  late final GeneratedColumn<String?> onlineTranslation =
      GeneratedColumn<String?>('online_translation', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, word, know, note, onlineTranslation];
  @override
  String get aliasedName => _alias ?? 'words';
  @override
  String get actualTableName => 'words';
  @override
  VerificationContext validateIntegrity(Insertable<Word> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('know')) {
      context.handle(
          _knowMeta, know.isAcceptableOrUnknown(data['know']!, _knowMeta));
    } else if (isInserting) {
      context.missing(_knowMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('online_translation')) {
      context.handle(
          _onlineTranslationMeta,
          onlineTranslation.isAcceptableOrUnknown(
              data['online_translation']!, _onlineTranslationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Word.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(_db, alias);
  }
}

class Content extends DataClass implements Insertable<Content> {
  final int id;
  final String title;
  final String content;
  final String data;
  Content(
      {required this.id,
      required this.title,
      required this.content,
      required this.data});
  factory Content.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Content(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      data: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['data'] = Variable<String>(data);
    return map;
  }

  ContentsCompanion toCompanion(bool nullToAbsent) {
    return ContentsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      data: Value(data),
    );
  }

  factory Content.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Content(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'data': serializer.toJson<String>(data),
    };
  }

  Content copyWith({int? id, String? title, String? content, String? data}) =>
      Content(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('Content(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Content &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.data == this.data);
}

class ContentsCompanion extends UpdateCompanion<Content> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> data;
  const ContentsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.data = const Value.absent(),
  });
  ContentsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.data = const Value.absent(),
  })  : title = Value(title),
        content = Value(content);
  static Insertable<Content> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (data != null) 'data': data,
    });
  }

  ContentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String>? data}) {
    return ContentsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $ContentsTable extends Contents with TableInfo<$ContentsTable, Content> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ContentsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _dataMeta = const VerificationMeta('data');
  late final GeneratedColumn<String?> data = GeneratedColumn<String?>(
      'data', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [id, title, content, data];
  @override
  String get aliasedName => _alias ?? 'contents';
  @override
  String get actualTableName => 'contents';
  @override
  VerificationContext validateIntegrity(Insertable<Content> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Content map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Content.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ContentsTable createAlias(String alias) {
    return $ContentsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $WordsTable words = $WordsTable(this);
  late final $ContentsTable contents = $ContentsTable(this);
  late final WordDao wordDao = WordDao(this as Database);
  late final ContentDao contentDao = ContentDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [words, contents];
}
