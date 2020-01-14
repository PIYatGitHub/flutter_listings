import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart'; //uncomment this in debug mode

//PROGRESS AS OF EOD: section 8 video 9 @ start

import './pages/auth.dart';
import './pages/products_manager.dart';
import './pages/products.dart';
import './pages/product.dart';
import 'pages/not_found.dart';

void main() {
  //debugPaintSizeEnabled = true; //helps if you want to see the layout highlighted
  //debugPointersEnabled=true; //shows the taps on the screen
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.deepPurple,
        primarySwatch: Colors.deepOrange,
        buttonColor: Colors.deepPurple,
      ),
      home: AuthPage(),
      routes: {
        '/products': (BuildContext context) => ProductsPage(_products),
        '/productsManager': (BuildContext context) =>
            ProductsManager(_addProduct, _deleteProduct),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split("/");
        if (pathElements[0] != '' || pathElements[1] != 'product') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => PageNotFound(),
          );
        }

        final int index = int.parse(pathElements[2]);
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => ProductPage(
              _products[index]['title'],
              _products[index]['description'],
              _products[index]['image'],
              _products[index]['price']),
        );
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => PageNotFound(),
        );
      },
    );
  }
}
