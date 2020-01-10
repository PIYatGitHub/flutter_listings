import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  ProductCreatePage(this.addProduct);
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _title = '';
  String _description = '';
  double _price = 0.0;

  _validateInputData(String title, double price) {
    if (title == '') {
      return 'Title cannot be empty!';
    }
    if (price < 0.0) {
      return 'Price must be greater or equal to zero!';
    }
    return 'OK';
  }

  _showToast(String message, bool isError) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _clearFields() {
    setState(() {
      _title = '';
      _description = '';
      _price = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Product Title'),
            onChanged: (String value) {
              setState(() {
                _title = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Description'),
            minLines: 2,
            maxLines: 5,
            onChanged: (String value) {
              setState(() {
                _description = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() {
                _price = double.parse(value);
              });
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text('SAVE'),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            onPressed: () {
              final Map<String, dynamic> product = {
                'title': _title,
                'description': _description,
                'price': _price,
                'image': 'assets/food.jpg'
              };
              final String validationResult =
                  _validateInputData(_title, _price);
              if (validationResult == 'OK') {
                widget.addProduct(product);
                _showToast('Product saved successfully!', false);
                _clearFields();
              } else {
                _showToast(validationResult, true);
              }
            },
          ),
        ],
      ),
    );
  }
}
