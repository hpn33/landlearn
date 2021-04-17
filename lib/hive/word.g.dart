// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordObjAdapter extends TypeAdapter<WordObj> {
  @override
  final int typeId = 0;

  @override
  WordObj read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordObj()
      ..word = fields[0] as String
      ..know = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, WordObj obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.know);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordObjAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
