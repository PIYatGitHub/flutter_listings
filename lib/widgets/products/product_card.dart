import 'package:flutter/material.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';
import '../products/address_tag.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;

  ProductCard(this.product, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleDefault(
                  product['title'],
                ),
                SizedBox(
                  width: 8.0,
                ),
                PriceTag(product['price'].toString()),
              ],
            ),
          ),
          AddressTag('United Arab Emirates'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/product/' + index.toString(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () => print('adding to favorites!'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
