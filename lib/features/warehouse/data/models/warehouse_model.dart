import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';

class WarehouseModel extends WarehouseEntity {
  WarehouseModel({
    required String id,
    required String name,
    required String location,
    String? imageUrl,
  }) : super(
          id: id,
          name: name,
          location: location,
          imageUrl: imageUrl,
        );

  /// Converts Firestore document to WarehouseModel
  factory WarehouseModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WarehouseModel(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  /// Converts WarehouseModel to Firestore document format
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
    };
  }

  /// Converts Domain Entity to Model
  factory WarehouseModel.fromEntity(WarehouseEntity entity) {
    return WarehouseModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      imageUrl: entity.imageUrl,
    );
  }

  /// Converts Model to Domain Entity
  WarehouseEntity toEntity() {
    return WarehouseEntity(
      id: id,
      name: name,
      location: location,
      imageUrl: imageUrl,
    );
  }
}
