// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localdb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalDBAdapter extends TypeAdapter<LocalDB> {
  @override
  final int typeId = 0;

  @override
  LocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalDB()
      ..userEmail = fields[0] as String
      ..uniqueId = fields[1] as String
      ..title = fields[2] as String
      ..description = fields[3] as String
      ..category = fields[4] as String
      ..priority = fields[5] as String
      ..dueDate = fields[6] as DateTime
      ..isCompleted = fields[7] as bool
      ..isFavorite = fields[8] as bool
      ..isPendingSync = fields[9] as bool;
  }

  @override
  void write(BinaryWriter writer, LocalDB obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userEmail)
      ..writeByte(1)
      ..write(obj.uniqueId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.dueDate)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.isPendingSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
