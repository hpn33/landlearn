// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectObjAdapter extends TypeAdapter<ProjectObj> {
  @override
  final int typeId = 0;

  @override
  ProjectObj read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectObj()
      ..title = fields[0] as String
      ..text = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, ProjectObj obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectObjAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
