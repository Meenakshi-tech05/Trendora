class WishlistModel {
  final String id;

  final String title;

  final String image;

  final double price;

  WishlistModel({
    required this.id,

    required this.title,

    required this.image,

    required this.price,
  });

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
      id: map['id'] ?? '',

      title: map['title'] ?? '',

      image: map['image'] ?? '',

      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'image': image, 'price': price};
  }
}
