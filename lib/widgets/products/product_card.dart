import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';
import '../products/address_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  ProductCard(this.product, this.index);

  Widget _buildPriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(
            product.title,
          ),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(product.price.toString()),
        ],
      ),
    );
  }

  Widget _buildBtnBar(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed<bool>(
                context,
                '/product/' + model.allProducts[index].id,
              ),
            ),
            IconButton(
              icon: Icon(model.isFavorited(index)
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.selectProduct(model.allProducts[index].id);
                model.toggleProductFavorite();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            placeholder: AssetImage('assets/food.jpg'),
            height: 300.0,
            fit: BoxFit.cover,
          ),
          _buildPriceRow(),
          Text(product.userEmail),
          Text(product.userId),
          AddressTag('United Arab Emirates'),
          _buildBtnBar(context),
        ],
      ),
    );
  }
}
