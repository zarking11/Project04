class User {
  int id;
  String username;
  String email;
  String password;

  User({this.id = 0, this.username = '', this.email = '', this.password = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return User();
    }
    return User(
      id: map['id'] as int? ?? 0,
      username: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }
}
