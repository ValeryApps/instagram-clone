import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_val/state/auth/models/auth_result.dart';
import 'package:insta_val/state/auth/notifiers/auth_state_notifier.dart';
import 'package:insta_val/state/auth/providers/auth_state_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.authResult == AuthResult.success;
});
