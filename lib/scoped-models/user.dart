import '.././models/user.dart';
import './connected_products.dart';

class UserModel extends ConnectedProducts {
  User get authUser {
    return authenticatedUser;
  }

  void login(String email, String password) {
    authenticatedUser = User(
      id: '1232533',
      email: email,
      password: password,
    );
    print('AUTH AS: $authenticatedUser');
  }
}
