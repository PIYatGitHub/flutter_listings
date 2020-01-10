import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whoops...'),
      ),
      body: Center(
        child: Text('Whoops... this page does not exist...'),
      ),
    );
  }
}
