import 'package:flutter/material.dart';
import 'package:flutter_listings/models/product.dart';
//import 'package:flutter_listings/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import 'package:flutter/rendering.dart'; //uncomment this in debug mode

//PROGRESS AS OF EOD: section 13 video 12 @ start

import './pages/auth.dart';
import './pages/products_manager.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';
import 'pages/not_found.dart';

Future main() async {
  //debugPaintSizeEnabled = true; //helps if you want to see the layout highlighted
  //debugPointersEnabled=true; //shows the taps on the screen
  await DotEnv().load('.env');
  runApp(FlutterListings());
}

class FlutterListings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FlutterListingsState();
  }
}

class _FlutterListingsState extends State<FlutterListings> {
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          accentColor: Colors.deepPurple,
          primarySwatch: Colors.deepOrange,
          buttonColor: Colors.deepPurple,
        ),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return model.authUser == null
                      ? AuthPage()
                      : ProductsPage(_model);
                },
              ),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/productsManager': (BuildContext context) => ProductsManager(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split("/");
          if (pathElements[0] != '' || pathElements[1] != 'product') {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => PageNotFound(),
            );
          }

          final String productId = pathElements[2];
          final Product product = _model.allProducts.firstWhere((Product item) {
            return item.id == productId;
          });
          //model.selectProduct(productId);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(product),
          );
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => PageNotFound(),
          );
        },
      ),
    );
  }
}
