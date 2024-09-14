// user_manager.dart
import 'user.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal();

  final List<User> _users = [];

  List<User> listUsers() => _users;

  void addUser(User user) {
    if (_users.any((existingUser) => existingUser.id == user.id)) {
      throw Exception('ID já existe');
    }
    _users.add(user);
  }

  void removeUser(String id) {
    _users.removeWhere((user) => user.id == id);
  }

}
