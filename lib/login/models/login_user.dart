class LoginUser {
  const LoginUser({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.loginMethod,
    required this.lastLoginAt,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    id: json['id'] as String,
    nickname: json['nickname'] as String,
    avatar: json['avatar'] as String,
    loginMethod: json['loginMethod'] as String,
    lastLoginAt: json['lastLoginAt'] as int,
  );

  final String id;
  final String nickname;
  final String avatar;
  final String loginMethod;
  final int lastLoginAt;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'nickname': nickname,
    'avatar': avatar,
    'loginMethod': loginMethod,
    'lastLoginAt': lastLoginAt,
  };

}
