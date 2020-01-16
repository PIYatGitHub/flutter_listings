import 'package:scoped_model/scoped_model.dart';

import '.././models/user.dart';

class UserModel extends Model {
  User _authenticatedUSer;

  User get authUser {
    return _authenticatedUSer;
  }

  void login(String email, String password) {
    _authenticatedUSer = User(
      id: '1232533',
      email: email,
      password: password,
    );
  }
}
