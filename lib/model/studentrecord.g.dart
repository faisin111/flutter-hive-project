// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentrecord.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentRecordAdapter extends TypeAdapter<StudentRecord> {
  @override
  final int typeId = 0;

  @override
  StudentRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentRecord(
      name: fields[0] as String,
      age: fields[1] as String,
      classs: fields[3] as String,
      address: fields[4] as String,
      imagePath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.classs)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
