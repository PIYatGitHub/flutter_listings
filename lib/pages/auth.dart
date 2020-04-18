import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  Map<String, dynamic> _loginData = {
    'email': null,
    'password': null,
    'acceptTerms': true
  };
  final RegExp _emailMatcher = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBgImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.dstATop,
      ),
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      initialValue: 'test@test.com',
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _loginData['email'] = value;
      },
      validator: (String value) {
        if (!_emailMatcher.hasMatch(value)) return 'Invalid email';
        return null;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      //initialValue: '12746316212',
      controller: _passwordTextController,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      onSaved: (String value) {
        _loginData['password'] = value;
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 6) return 'Invalid password';
        return null;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) return 'Password mismatch';
        return null;
      },
    );
  }

  SwitchListTile _buildListTile() {
    return SwitchListTile(
      title: Text('Accept terms'),
      value: _loginData['acceptTerms'],
      onChanged: (bool value) {
        _loginData['acceptTerms'] = value;
      },
    );
  }

  Widget _buildSizedBox() => SizedBox(height: 10.0);

  Widget _buildRaisedBtn() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.login, model.signup),
        );
      },
    );
  }

  Widget _buildSwitchModeBtn() {
    return FlatButton(
      child:
          Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
      onPressed: () {
        setState(() {
          _authMode =
              _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
        });
      },
    );
  }

  void _submitForm(Function login, Function signup) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_authMode == AuthMode.Login) {
      login(_loginData['email'], _loginData['password']);
    } else {
      final Map<String, dynamic> successInfo =
          await signup(_loginData['email'], _loginData['password']);
      if (successInfo['success']) {
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('An error occurred'),
                content: Text(successInfo['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double width = deviceWidth >= 640.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
            image: _buildBgImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: width,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      _buildSizedBox(),
                      _buildPasswordTextField(),
                      _buildSizedBox(), //new
                      _authMode == AuthMode.Signup
                          ? _buildPasswordConfirmTextField()
                          : Container(), //new
                      _authMode == AuthMode.Signup
                          ? _buildSizedBox()
                          : Container(), //new
                      _buildSwitchModeBtn(), //new
                      _authMode == AuthMode.Signup
                          ? _buildListTile()
                          : Container(),
                      _buildSizedBox(),
                      _buildRaisedBtn(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
