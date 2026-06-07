import 'auth_dao.dart';
import 'auth_model.dart';
import 'dao.dart';
import 'model.dart';

class AuthRepository {
  final AuthDao _authDao = AuthDao();
  final AppDao _appDao = AppDao();

  Future<AuthUser?> login(String username, String password) {
    return _authDao.getUserByCredentials(username, password);
  }

  Future<String?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    if (await _authDao.usernameExists(username)) {
      return 'This username is already taken.';
    }
    if (await _authDao.emailExists(email)) {
      return 'This email is already registered.';
    }
    final linkedUserId = await _appDao.insertUser(
      User(name: '$firstName $lastName'),
    );
    await _authDao.insertUser(AuthUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
      role: 'user',
      linkedUserId: linkedUserId,
    ));
    return null;
  }

  Future<String?> updateProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    if (firstName.isEmpty || lastName.isEmpty || password.isEmpty) {
      return 'Fields cannot be empty.';
    }
    if (password.length < 6) return 'Password must be at least 6 characters.';
    await _authDao.updateProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      password: password,
    );
    return null;
  }
}