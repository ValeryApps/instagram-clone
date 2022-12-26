import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_val/state/constants/firebase_collection_name.dart';
import 'package:insta_val/state/constants/firebase_filed_name.dart';
import 'package:insta_val/state/posts/typedef/user_id.dart';
import 'package:insta_val/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();
  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      //first check if we this user's info from before.
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();
      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }
      //we don't have this user's info from before, create a new user;

      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );
      FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);
      return true;
    } catch (e) {
      return false;
    }
  }
}
