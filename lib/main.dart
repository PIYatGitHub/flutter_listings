import 'package:flutter/material.dart';

import 'package:flutter_listings/pages/home.dart';
//import 'package:flutter/rendering.dart'; //uncomment this in debug mode

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
        home: HomePage());
  }
}
