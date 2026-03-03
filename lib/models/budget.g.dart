

part of 'budget.dart';





class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 2;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      id: fields[0] as String,
      categoryId: fields[1] as String,
      categoryName: fields[2] as String,
      amount: fields[3] as double,
      period: fields[4] as String,
      month: fields[5] as int,
      year: fields[6] as int,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      isGlobal: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.period)
      ..writeByte(5)
      ..write(obj.month)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isGlobal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
