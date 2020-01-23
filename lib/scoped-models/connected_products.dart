import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/product.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
  final String baseUrl = 'https://flutterlistings.firebaseio.com/';
  final String imageUrl =
      'https://cdn.pixabay.com/photo/2013/09/18/18/24/chocolate-183543_960_720.jpg';

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
      'image': imageUrl,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };

    return http
        .post(baseUrl + 'products.json', body: json.encode(productData))
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

  String get selectedProductId {
    return _selProductId;
  }

  bool get displayFavsOnly {
    return _showFavorites;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  void toggleProductFavorite() {
    final bool isFavorite = selectedProduct.isFavorite;
    final bool newFavStatus = !isFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavorite: newFavStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  bool isFavorited(int index) {
    return _products[index].isFavorite;
  }

  Future<Null> updateProduct(
    String title,
    String description,
    double price,
    String image,
  ) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'price': price,
      'image': imageUrl,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
    };

    return http
        .put(baseUrl + 'products/${selectedProduct.id}.json',
            body: jsonEncode(updateData))
        .then((http.Response response) {
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        price: price,
        image: imageUrl,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
      );
      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> deleteProduct() {
    final deletedItemId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    _isLoading = true;
    notifyListeners();
    return http
        .delete(baseUrl + 'products/$deletedItemId.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get(baseUrl + 'products.json').then((http.Response response) {
      final List<Product> fetchedProdList = [];
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
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

  void showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
