import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class ProductsManager extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;
  ProductsManager(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text('All Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/products');
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Products Manager'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductCreatePage(addProduct),
            ProductsListPage(),
          ],
        ),
      ),
    );
  }
}
