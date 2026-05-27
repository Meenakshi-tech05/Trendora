class ProductModel {
  final String id;
  final String title;
  final double price;
  final String image;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,

      title: data['title'] ?? '',

      price: (data['price'] ?? 0).toDouble(),

      image: data['image'] ?? '',

      category: data['category'] ?? '',
    );
  }
}
