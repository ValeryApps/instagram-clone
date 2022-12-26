import 'package:flutter/foundation.dart';

import '../../posts/typedef/user_id.dart';
import 'auth_result.dart';

@immutable
class AuthState {
  final AuthResult? authResult;
  final UserId? userId;
  final bool isLoading;

  AuthState({
    required this.authResult,
    required this.userId,
    required this.isLoading,
  });

  const AuthState.unknown()
      : authResult = null,
        userId = null,
        isLoading = false;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        authResult: authResult,
        userId: userId,
        isLoading: isLoading,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (authResult == other.authResult &&
          userId == other.userId &&
          isLoading == other.isLoading);

  @override
  int get hashCode => Object.hash(
        authResult,
        userId,
        isLoading,
      );
}
