import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:re_vision/base_widgets/base_snackbar.dart';
import 'package:re_vision/constants/icon_constants.dart';

class BaseAuth {
  static FirebaseAuth? _fireInst;

  /// Gets a app wide reference for the currently logged in user.
  static currentUser() {
    return _fireInst!.currentUser;
  }

  /// Initialise the [BaseAuth] in the main function before using it.
  ///
  static Future<FirebaseAuth?> init() async {
    _fireInst = FirebaseAuth.instance;
    return _fireInst;
  }

  /// Sign-in the user with credentials. For google.
  static Future<User?> signIn(BuildContext context) async {
    User? user;

    // Trigger the authentication flow.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        // Once signed in, get the user credential.
        final UserCredential? userCredential =
            await _fireInst?.signInWithCredential(credential);
        user = userCredential?.user;
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        _firebaseAuthException(e, context);
      } catch (e) {
        debugPrint(e.toString());
        // ignore: use_build_context_synchronously
        baseSnackBar(context,
            message: 'Error occurred using Google Sign-In. Try again.',
            leading: IconConstants.failed);
      }
    }

    return user;
  }

  static Future<User?> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      final UserCredential? credential = await _fireInst
          ?.signInWithEmailAndPassword(email: email, password: password);
      user = credential?.user;
    } on FirebaseAuthException catch (e) {
      _firebaseAuthException(e, context);
    } catch (e) {
      debugPrint(e.toString());
      baseSnackBar(
        context,
        message: 'Error occurred using Google Sign-In. Try again.',
        leading: IconConstants.failed,
      );
    }

    return user;
  }

  /// Sign-out the user.
  static Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      baseSnackBar(context,
          message: 'Error signing out. Try again.',
          leading: IconConstants.failed);
    }
  }

  /// To display [BaseSnackBar] when there's some firebase related exceptions.
  static void _firebaseAuthException(
      FirebaseAuthException e, BuildContext context) {
    if (e.code == 'account-exists-with-different-credential') {
      baseSnackBar(context,
          message: 'The account already exists with a different credential.',
          leading: IconConstants.failed);
    } else if (e.code == 'invalid-credential') {
      baseSnackBar(context,
          message: 'Error occurred while accessing credentials. Try again.',
          leading: IconConstants.failed);
    }
  }
}
