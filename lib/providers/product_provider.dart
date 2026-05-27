import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product_model.dart';
import '../data/services/product_services.dart';

final productProvider = StreamProvider<List<ProductModel>>((ref) {
  return ProductService().getProducts();
});
