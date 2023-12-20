class User {
  int? userId;
  String access_token;
  String refresh_token;

  User({this.userId, required this.access_token, required this.refresh_token});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        access_token: responseData['access_token'],
        refresh_token: responseData['refresh_token']);
  }
}
//user id 는 보류