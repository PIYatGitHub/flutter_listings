import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  Widget _buildLocationPriceTag(double price) {
    return Container(
      child: Text(
        'Union Sq., San Francisco | \$ ${price.toString()}',
        style: TextStyle(
          fontFamily: 'Oswald',
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          final Product product = model.selectedProduct;
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title),
            ),
            body: Column(
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(product.image),
                  placeholder: AssetImage('assets/food.jpg'),
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(product.title),
                ),
                _buildLocationPriceTag(product.price),
                SizedBox(
                  height: 6.0,
                ),
                Container(
                  child: Text(product.description),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
