class CartModel {
  final String title;

  final String image;

  final double price;

  final int quantity;

  final String size;
  final String id;

  CartModel({
    required this.id,
    required this.title,

    required this.image,

    required this.price,

    required this.quantity,

    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "title": title,

      "image": image,

      "price": price,

      "quantity": quantity,

      "size": size,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      title: map['title'] ?? "",

      image: map['image'] ?? "",

      price: (map['price'] ?? 0).toDouble(),

      quantity: map['quantity'] ?? 1,

      size: map['size'] ?? "",
    );
  }
  CartModel copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    int? quantity,
    String? size,
  }) {
    return CartModel(
      id: id ?? this.id,

      title: title ?? this.title,

      image: image ?? this.image,

      price: price ?? this.price,

      quantity: quantity ?? this.quantity,

      size: size ?? this.size,
    );
  }
}
