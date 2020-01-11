import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email = '';
  String _password = '';
  bool _acceptTerms = true;

  _validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.dstATop,
            ),
            image: AssetImage('assets/background.jpg'),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Accept terms'),
                value: _acceptTerms,
                onChanged: (bool value) {
                  setState(() {
                    _acceptTerms = value;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('LOGIN'),
                onPressed: () {
                  final bool isValid = _validateEmail(_email);
                  if (!isValid) {
                    _showToast('Invalid email');
                  } else {
                    Navigator.pushReplacementNamed(context, '/products');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
