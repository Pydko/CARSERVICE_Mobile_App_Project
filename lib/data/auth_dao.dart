import 'database.dart';
import 'auth_model.dart';

class AuthDao {
  Future<int> insertUser(AuthUser user) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('auth_users', {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'username': user.username,
      'password': user.password,
      'role': user.role,
      'linkedUserId': user.linkedUserId,
    });
  }

  Future<AuthUser?> getUserByCredentials(String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'auth_users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isEmpty) return null;
    return AuthUser.fromMap(result.first);
  }

  Future<bool> usernameExists(String username) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'auth_users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<bool> emailExists(String email) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'auth_users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<int> updateProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'auth_users',
      {'firstName': firstName, 'lastName': lastName, 'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}