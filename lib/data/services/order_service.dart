import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> placeOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  String get currentUserId {
    return _auth.currentUser!.uid;
  }

  Stream<QuerySnapshot> getUserOrders() {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
  }
}
