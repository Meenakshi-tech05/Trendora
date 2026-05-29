import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// PLACE ORDER
  Future<void> placeOrder({
    required List<CartModel> cartItems,

    required double totalAmount,

    required String address,

    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    /// SAVE ORDER
    await _firestore.collection('orders').add({
      /// USER INFO
      'userId': user.uid,

      /// TOTAL
      'totalAmount': totalAmount,

      /// ADDRESS
      'address': address,

      /// PAYMENT
      'paymentMethod': paymentMethod,

      /// STATUS
      'orderStatus': 'Order Placed',

      /// CREATED TIME
      'createdAt': Timestamp.now(),

      /// ORDER ITEMS
      'items': cartItems.map((item) {
        return {
          'id': item.id,

          'title': item.title,

          'image': item.image,

          'price': item.price,

          'quantity': item.quantity,

          'size': item.size,
        };
      }).toList(),
    });

    /// CLEAR CART AFTER ORDER
    final cartDocs = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .get();

    for (var doc in cartDocs.docs) {
      await doc.reference.delete();
    }
  }

  /// GET USER ORDERS
  Stream<QuerySnapshot> getOrders() {
    final user = FirebaseAuth.instance.currentUser;

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// UPDATE ORDER STATUS
  Future<void> updateOrderStatus({
    required String orderId,

    required String status,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'orderStatus': status,
    });
  }
}
