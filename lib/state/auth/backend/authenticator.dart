import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta_val/state/auth/constants/constants.dart';
import 'package:insta_val/state/auth/models/auth_result.dart';
import 'package:insta_val/state/posts/typedef/user_id.dart';

class Authenticator {
  const Authenticator();
  FirebaseAuth get auth => FirebaseAuth.instance;
  UserId? get userId => auth.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName => auth.currentUser?.displayName ?? "";
  String? get email => auth.currentUser?.email;
  String? get photoUrl => auth.currentUser?.photoURL;

  Future<void> logOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFaceBook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final String? token = loginResult.accessToken?.token;
      if (token == null) {
        //user has aborted the operation
        return AuthResult.aborted;
      }
      final OAuthCredential oauthCredential =
          FacebookAuthProvider.credential(token);

      UserCredential userCredential =
          await auth.signInWithCredential(oauthCredential);
      return AuthResult.success;
    } on FirebaseAuthException catch (err) {
      final email = err.email;
      final credential = err.credential;
      if (err.code == Constants.accountExistWithDifferentCredentials &&
          email != null &&
          credential != null) {
        final provider = await auth.fetchSignInMethodsForEmail(email);
        if (provider.contains(Constants.googleCom)) {
          await loginWithGoogle();
          auth.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    } catch (e) {
      print(e.toString());
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }
    final GoogleSignInAuthentication googleAuth =
        await signInAccount.authentication;
    final OAuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(authCredential);
      return AuthResult.success;
    } catch (e) {
      print(e);
      return AuthResult.failure;
    }
  }
}
