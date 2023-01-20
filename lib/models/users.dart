class User {
  final String id;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.roles,
  });

  /*factory Use8r.fromJson(Map<String, dynamic>json) {
    return User(
  id: json['id'],
  email: json['email'],
  roles: json['roles'],
    );
  }*/
}
