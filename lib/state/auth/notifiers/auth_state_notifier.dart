import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_val/state/auth/backend/authenticator.dart';
import 'package:insta_val/state/auth/models/auth_result.dart';
import 'package:insta_val/state/posts/typedef/user_id.dart';
import 'package:insta_val/state/user_info/backend/user_info_storage.dart';

import '../models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        authResult: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final authResult = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (authResult == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      authResult: authResult,
      userId: userId,
      isLoading: false,
    );
  }

  Future<void> loginWithFaceBook() async {
    state = state.copiedWithIsLoading(true);
    final authResult = await _authenticator.loginWithFaceBook();
    final userId = _authenticator.userId;
    if (authResult == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      authResult: authResult,
      userId: userId,
      isLoading: false,
    );
  }

  Future<void> saveUserInfo({required UserId userId}) async {
    _userInfoStorage.saveUserInfo(
      userId: userId,
      displayName: _authenticator.displayName,
      email: _authenticator.email,
    );
  }
}
