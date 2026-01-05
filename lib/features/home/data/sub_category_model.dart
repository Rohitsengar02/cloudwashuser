class SubCategoryModel {
  final String id;
  final String name;
  final String categoryId;
  final String description;
  final double price;
  final String imageUrl;
  final bool isActive;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isActive,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryId: json['category'] is Map
          ? json['category']['_id']
          : (json['category'] ?? ''),
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
}
