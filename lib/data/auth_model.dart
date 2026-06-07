class AuthUser {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String role;
  final int? linkedUserId;

  AuthUser({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    this.linkedUserId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': username,
        'password': password,
        'role': role,
        'linkedUserId': linkedUserId,
      };

  factory AuthUser.fromMap(Map<String, dynamic> map) => AuthUser(
        id: map['id'] as int?,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        role: map['role'] as String,
        linkedUserId: map['linkedUserId'] as int?,
      );
}