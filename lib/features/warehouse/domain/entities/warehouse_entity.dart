class WarehouseEntity {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;

  WarehouseEntity({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
  });
}
