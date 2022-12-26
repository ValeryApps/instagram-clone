import 'dart:collection' show MapView;

import 'package:flutter/material.dart';
import 'package:insta_val/state/constants/firebase_filed_name.dart';
import 'package:insta_val/state/posts/typedef/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload(
      {required UserId userId,
      required String? displayName,
      required String? email})
      : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName ?? '',
          FirebaseFieldName.email: email ?? ''
        });
}
