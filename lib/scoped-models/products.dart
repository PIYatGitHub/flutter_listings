import '../models/product.dart';
import './connected_products.dart';

class ProductsModel extends ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get products {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    List<Product> result = List.from(products);
    if (_showFavorites) {
      result = result.where((Product p) => p.isFavorite).toList();
    }
    return result;
  }

  int get selectedProductIndex {
    return selectedProductIndex;
  }

  bool get displayFavsOnly {
    return _showFavorites;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  void toggleProductFavorite() {
    final bool isFavorite = selectedProduct.isFavorite;
    final bool newFavStatus = !isFavorite;
    final Product updatedProduct = Product(
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      isFavorite: newFavStatus,
    );
    products[selectedProductIndex] = updatedProduct;
    selectedProductIndex = null;
    notifyListeners();
  }

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
    );
    products.add(newProduct);
    selectedProductIndex = null;
    notifyListeners();
  }

  bool isFavorited(int index) {
    return products[index].isFavorite;
  }

  void updateProduct(Product product) {
    products[selectedProductIndex] = product;
    selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selectedProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    selectedProductIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
