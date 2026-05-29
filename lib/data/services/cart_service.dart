import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ADD TO CART
  Future<void> addToCart(CartModel item) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    /// CHECK EXISTING ITEM
    final query = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .where('id', isEqualTo: item.id)
        .where('size', isEqualTo: item.size)
        .get();

    /// ITEM EXISTS -> INCREASE QUANTITY
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      final currentQty = doc['quantity'];

      await doc.reference.update({'quantity': currentQty + 1});

      return;
    }

    /// NEW ITEM
    await _firestore.collection('cart').add({
      'userId': user.uid,

      'id': item.id,

      'title': item.title,

      'image': item.image,

      'price': item.price,

      'quantity': item.quantity,

      'size': item.size,
    });
  }

  /// GET CART ITEMS
  Stream<List<CartModel>> getCartItems() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return CartModel(
              id: data['id'] ?? '',

              title: data['title'] ?? '',

              image: data['image'] ?? '',

              price: (data['price'] ?? 0).toDouble(),

              quantity: data['quantity'] ?? 1,

              size: data['size'] ?? '',
            );
          }).toList();
        });
  }

  /// INCREASE QUANTITY
  Future<void> increaseQuantity(CartModel item) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final query = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .where('id', isEqualTo: item.id)
        .where('size', isEqualTo: item.size)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      final currentQty = doc['quantity'];

      await doc.reference.update({'quantity': currentQty + 1});
    }
  }

  /// DECREASE QUANTITY
  Future<void> decreaseQuantity(CartModel item) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final query = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .where('id', isEqualTo: item.id)
        .where('size', isEqualTo: item.size)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      final currentQty = doc['quantity'];

      /// REMOVE ITEM IF QTY = 1
      if (currentQty <= 1) {
        await doc.reference.delete();
      } else {
        await doc.reference.update({'quantity': currentQty - 1});
      }
    }
  }

  /// REMOVE FROM CART
  Future<void> removeFromCart(CartModel item) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final query = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .where('id', isEqualTo: item.id)
        .where('size', isEqualTo: item.size)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  /// CLEAR CART
  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final query = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }
}
