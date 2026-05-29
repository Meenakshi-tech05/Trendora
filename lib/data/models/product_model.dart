class ProductModel {
  final String id;

  final String title;

  final String category;

  final String description;

  final String image;

  final double price;

  final List<String> sizes;

  ProductModel({
    required this.id,

    required this.title,

    required this.category,

    required this.description,

    required this.image,

    required this.price,

    required this.sizes,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',

      title: map['title'] ?? '',

      category: map['category'] ?? '',

      description: map['description'] ?? '',

      image: map['image'] ?? '',

      price: (map['price'] ?? 0).toDouble(),

      sizes: List<String>.from(map['sizes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'title': title,

      'category': category,

      'description': description,

      'image': image,

      'price': price,

      'sizes': sizes,
    };
  }
}
