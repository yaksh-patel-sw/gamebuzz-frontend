class User {
  final String username;
  final String password;

  User({
    required this.username,
    required this.password,
  });

  // Convert User object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  // Factory constructor to create a User from JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
    );
  }
}
