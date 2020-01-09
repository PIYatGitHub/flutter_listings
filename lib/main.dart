import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart'; //uncomment this in debug mode

import './product_manager.dart';

void main() {
  //debugPaintSizeEnabled = true; //helps if you want to see the layout highlighted
  //debugPointersEnabled=true; //shows the taps on the screen
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: Colors.deepPurple, primarySwatch: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(
          title: Text('EasyList'),
        ),
        body: ProductManager('Super secret product 1'),
      ),
    );
  }
}
