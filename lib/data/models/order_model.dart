class OrderModel {
  final String userId;

  final List items;

  final double total;

  final String address;

  final String paymentMethod;

  final String status;

  OrderModel({
    required this.userId,

    required this.items,

    required this.total,

    required this.address,

    required this.paymentMethod,

    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,

      "items": items,

      "total": total,

      "address": address,

      "paymentMethod": paymentMethod,

      "status": status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] ?? "",

      items: map['items'] ?? [],

      total: (map['total'] ?? 0).toDouble(),

      address: map['address'] ?? "",

      paymentMethod: map['paymentMethod'] ?? "",

      status: map['status'] ?? "Order Placed",
    );
  }
}
