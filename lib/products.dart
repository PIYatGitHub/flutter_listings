import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          SizedBox(
            height: 10.0,
          ),
          Text(
            products[index]['title'],
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald'),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  child: Text("Details"),
                  onPressed: () => Navigator.pushNamed<bool>(
                        context,
                        '/product/' + index.toString(),
                      ))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    Widget productCard = Center(
      child: Text('No items found. Please use the button above.'),
    );
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductsList();
  }
}
