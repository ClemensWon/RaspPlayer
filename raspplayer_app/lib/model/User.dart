class User {
  String id;
  String username;
  String role;
  bool isMuted;
  bool isBanned;

  User({this.id, this.username, this.role, this.isMuted, this.isBanned});

  factory User.fromJson(final json) {
    return User(id: json['id'] as String, username: json['username'] as String, role: json['role'] as String, isMuted: json['isMuted'] as bool, isBanned: json['isBanned'] as bool);
  }
}