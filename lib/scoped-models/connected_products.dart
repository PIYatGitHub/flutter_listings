import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';
import '../models/product.dart';

class ConnectedProducts extends Model {
  List<Product> products = [];
  User authenticatedUser;
  int selectedProductIndex;

  void addProduct({
    String title,
    String description,
    double price,
    String image,
  }) {
    final Product newProduct = Product(
      title: title,
      description: description,
      price: price,
      image: image,
      userEmail: authenticatedUser.email,
      userId: authenticatedUser.id,
    );
    products.add(newProduct);
    selectedProductIndex = null;
    notifyListeners();
  }
}
