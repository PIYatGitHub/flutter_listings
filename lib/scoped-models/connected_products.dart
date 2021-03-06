import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/user.dart';
import '../models/product.dart';
import '../models/auth.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
  final String baseUrl = 'https://flutterlistings.firebaseio.com';
  final String imageUrl =
      'https://cdn.pixabay.com/photo/2013/09/18/18/24/chocolate-183543_960_720.jpg';
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  Future<bool> addProduct(
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
        .post('$baseUrl/products.json?auth=${_authenticatedUser.token}',
            body: json.encode(productData))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
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
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

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

  void toggleProductFavorite() async {
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

    http.Response response;

    if (newFavStatus) {
      response = await http.put(
          '$baseUrl/products/${selectedProduct.id}/whishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          '$baseUrl/products/${selectedProduct.id}/whishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          image: selectedProduct.image,
          price: selectedProduct.price,
          isFavorite: !newFavStatus,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  bool isFavorited(int index) {
    return _products[index].isFavorite;
  }

  Future<bool> updateProduct(
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
        .put(
            '$baseUrl/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
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
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    final deletedItemId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    _isLoading = true;
    notifyListeners();
    return http
        .delete(
            '$baseUrl/products/$deletedItemId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
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

  Future<Null> fetchProducts({userRelatedOnly = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get('$baseUrl/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProdList = [];
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      responseData.forEach((String productId, dynamic productData) {
        bool isFavorited = false;
        if (productData['whishlistUsers'] != null) {
          isFavorited = (productData['whishlistUsers'] as Map<String, dynamic>)
              .containsKey(_authenticatedUser.id);
        }
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: isFavorited);
        fetchedProdList.add(product);
      });
      _products = userRelatedOnly
          ? fetchedProdList.where((Product product) {
              return product.userId == _authenticatedUser.id;
            }).toList()
          : fetchedProdList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}

class UserModel extends ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get authUser {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final key = DotEnv().env['FIREBASE_API_KEY'];
    final url = mode == AuthMode.Login
        ? 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$key'
        : 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$key';
    final http.Response response = await http.post(
      url,
      body: jsonEncode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> parsed = json.decode(response.body);
    bool hasError = true;
    String message = 'Auth failed!';
    if (parsed.containsKey('idToken')) {
      hasError = false;
      message = 'Auth succeeded!';

      _authenticatedUser = new User(
          id: parsed['localId'],
          email: parsed['email'],
          token: parsed['idToken']);

      _userSubject.add(true);

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setString('token', parsed['idToken']);
      preferences.setString('userEmail', parsed['email']);
      preferences.setString('userId', parsed['localId']);

      final int expiresIn = int.parse(parsed['expiresIn']);
      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: expiresIn));
      setAuthTimeout(expiresIn);
      preferences.setString('expiryTime', expiryTime.toIso8601String());
    } else if (parsed['error']['message'] == 'EMAIL_NOT_FOUND') {
      message += ' Email not found.';
    } else if (parsed['error']['message'] == 'INVALID_PASSWORD') {
      message += ' Password is invalid.';
    } else if (parsed['error']['message'] == 'EMAIL_EXISTS') {
      message += ' Email already taken.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'msg': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');
    final String expiryTime = preferences.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedTime = DateTime.parse(expiryTime);
      if (parsedTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = preferences.getString('userEmail');
      final String userId = preferences.getString('userId');
      final int tokenLifespan = parsedTime.difference(now).inSeconds;
      _authenticatedUser = new User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    print('blazing through logout');

    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    preferences.remove('userEmail');
    preferences.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }

  void showToast(bool flag) {
    Fluttertoast.showToast(
        msg: flag ? 'Operation succeeded!' : 'Operation failed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: flag ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
