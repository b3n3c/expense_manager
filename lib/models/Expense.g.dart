// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      fields[1] as String,
      fields[2] as double,
      fields[3] as String,
      fields[4] as String,
      fields[5] as double,
      fields[6] as double,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as int,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.receiptPath)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lng)
      ..writeByte(7)
      ..write(obj.addressName)
      ..writeByte(8)
      ..write(obj.contactName)
      ..writeByte(9)
      ..write(obj.contactNumber)
      ..writeByte(10)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
