class WarehouseEntity {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;
  final String? companyId; // Added companyId here

  WarehouseEntity({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
    this.companyId, // Added companyId to the constructor
  });
}
