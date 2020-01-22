import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/product.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;
  bool _isLoading = false;

  Future<Null> addProduct(
    String title,
    String description,
    double price,
    String image,
  ) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://cdn.pixabay.com/photo/2013/09/18/18/24/chocolate-183543_960_720.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };

    return http
        .post(
      'https://flutterlistings.firebaseio.com/products.json',
      body: json.encode(productData),
    )
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
      );
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
    });
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    List<Product> result = List.from(_products);
    if (_showFavorites) {
      result = result.where((Product p) => p.isFavorite).toList();
    }
    return result;
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  bool get displayFavsOnly {
    return _showFavorites;
  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return null;
    }
    return _products[_selProductIndex];
  }

  void toggleProductFavorite() {
    final bool isFavorite = selectedProduct.isFavorite;
    final bool newFavStatus = !isFavorite;
    final Product updatedProduct = Product(
        id: '123',
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavorite: newFavStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[_selProductIndex] = updatedProduct;
    notifyListeners();
  }

  bool isFavorited(int index) {
    return _products[index].isFavorite;
  }

  void updateProduct(
    String title,
    String description,
    double price,
    String image,
  ) {
    final Product updatedProduct = Product(
      id: '123',
      title: title,
      description: description,
      price: price,
      image: image,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
    );
    _products[_selProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selProductIndex);
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http
        .get('https://flutterlistings.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProdList = [];
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData != null) {
        responseData.forEach((String productId, dynamic productData) {
          final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
          );
          fetchedProdList.add(product);
        });
        _products = fetchedProdList;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        return;
      }
    });
  }
}

class UserModel extends ConnectedProductsModel {
  User get authUser {
    return _authenticatedUser;
  }

  void login(String email, String password) {
    _authenticatedUser = User(
      id: '1232533',
      email: email,
      password: password,
    );
    print('AUTH AS: $_authenticatedUser');
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
