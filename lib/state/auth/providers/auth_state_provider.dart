import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_val/state/auth/models/auth_state.dart';
import 'package:insta_val/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((_) {
  return AuthStateNotifier();
});
