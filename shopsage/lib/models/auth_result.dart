class AuthResult {
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  const AuthResult({
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : null;
    return AuthResult(
      message: json['message']?.toString() ?? 'Success',
      accessToken: data?['accessToken']?.toString(),
      refreshToken: data?['refreshToken']?.toString(),
      user: data?['user'] is Map<String, dynamic>
          ? data!['user'] as Map<String, dynamic>
          : null,
    );
  }
}
