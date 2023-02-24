class UserResponse {
  int? pk;
  String username;
  String? email;
  String? first_name;
  String? last_name;
  String? user_type;

  UserResponse(
      {this.pk,
      required this.username,
      this.email,
      this.first_name,
      this.last_name,
      this.user_type});

  factory UserResponse.fromJson(jsonBody) {
    final pk = jsonBody['pk'];
    final username = jsonBody['username'];
    final email = jsonBody['email'];
    final first_name = jsonBody['first_name'];
    final last_name = jsonBody['last_name'];
    final user_type = jsonBody['user_type'];
    return UserResponse(
        pk: pk,
        username: username,
        first_name: first_name,
        last_name: last_name,
        user_type: user_type);
  }
}
