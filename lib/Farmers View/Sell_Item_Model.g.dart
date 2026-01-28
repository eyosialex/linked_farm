// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Sell_Item_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgriculturalItemAdapter extends TypeAdapter<AgriculturalItem> {
  @override
  final int typeId = 0;

  @override
  AgriculturalItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgriculturalItem(
      id: fields[0] as String?,
      name: fields[1] as String,
      category: fields[2] as String,
      subcategory: fields[3] as String?,
      description: fields[4] as String,
      price: fields[5] as double,
      quantity: fields[6] as int,
      unit: fields[7] as String,
      condition: fields[8] as String,
      imageUrls: (fields[9] as List?)?.cast<String>(),
      localImagePaths: (fields[25] as List?)?.cast<String>(),
      location: (fields[10] as Map?)?.cast<String, double>(),
      address: fields[11] as String?,
      sellerName: fields[12] as String,
      sellerId: fields[13] as String,
      contactInfo: fields[14] as String,
      availableFrom: fields[15] as DateTime?,
      deliveryAvailable: fields[16] as bool,
      tags: (fields[17] as List?)?.cast<String>(),
      likes: fields[20] as int,
      views: fields[21] as int,
      likedBy: (fields[22] as List).cast<String>(),
      viewedBy: (fields[23] as List).cast<String>(),
      isSynced: fields[24] as bool,
      createdAt: fields[18] as DateTime?,
      updatedAt: fields[19] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AgriculturalItem obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.subcategory)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.condition)
      ..writeByte(9)
      ..write(obj.imageUrls)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.address)
      ..writeByte(12)
      ..write(obj.sellerName)
      ..writeByte(13)
      ..write(obj.sellerId)
      ..writeByte(14)
      ..write(obj.contactInfo)
      ..writeByte(15)
      ..write(obj.availableFrom)
      ..writeByte(16)
      ..write(obj.deliveryAvailable)
      ..writeByte(17)
      ..write(obj.tags)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(20)
      ..write(obj.likes)
      ..writeByte(21)
      ..write(obj.views)
      ..writeByte(22)
      ..write(obj.likedBy)
      ..writeByte(23)
      ..write(obj.viewedBy)
      ..writeByte(24)
      ..write(obj.isSynced)
      ..writeByte(25)
      ..write(obj.localImagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgriculturalItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
