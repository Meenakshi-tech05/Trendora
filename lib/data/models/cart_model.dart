class CartModel {
  final String title;

  final String image;

  final double price;

  final int quantity;

  final String size;

  CartModel({
    required this.title,

    required this.image,

    required this.price,

    required this.quantity,

    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,

      "image": image,

      "price": price,

      "quantity": quantity,

      "size": size,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      title: map['title'] ?? "",

      image: map['image'] ?? "",

      price: (map['price'] ?? 0).toDouble(),

      quantity: map['quantity'] ?? 1,

      size: map['size'] ?? "",
    );
  }
}
