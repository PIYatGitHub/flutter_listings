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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Widget _buildTitleTextField() {
    return TextFormField(
      onSaved: (String value) {
        setState(() {
          _title = value;
        });
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return 'Title is required and is 5+ characters long';
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Product Title',
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      minLines: 2,
      maxLines: 5,
      onSaved: (String value) {
        setState(() {
          _description = value;
        });
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 10)
          return 'Description is required and is 10+ characters long';
        return null;
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        setState(() {
          _price = double.parse(value);
        });
      },
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value))
          return 'Price is required and must be a number';
        return null;
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final Map<String, dynamic> product = {
      'title': _title,
      'description': _description,
      'price': _price,
      'image': 'assets/food.jpg'
    };
    final String validationResult = _validateInputData(_title, _price);
    if (validationResult == 'OK') {
      widget.addProduct(product);
      _showToast('Product saved successfully!', false);
      Navigator.pushReplacementNamed(context, '/products');
    } else {
      _showToast(validationResult, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextField(),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text('SAVE'),
                textColor: Colors.white,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
