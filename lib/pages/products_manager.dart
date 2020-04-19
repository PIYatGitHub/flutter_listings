import 'package:flutter/material.dart';
import 'package:flutter_listings/scoped-models/main.dart';

import './product_edit.dart';
import './product_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class ProductsManager extends StatelessWidget {
  final MainModel model;
  ProductsManager(this.model);

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
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
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildDrawer(context),
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
            ProductEditPage(),
            ProductsListPage(model),
          ],
        ),
      ),
    );
  }
}
