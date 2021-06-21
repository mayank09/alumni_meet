import 'package:alumnimeet/firebase/firestore.dart';
import 'package:alumnimeet/ui/homePage.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<FirebaseApp> initializeFirebase(BuildContext context) async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(
          user: user,
        ),
      ),
    );
  }
  return firebaseApp;
}

Future<User?> registerUsingEmailPassword(
    {required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phoneNumber}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
    await user!.updateDisplayName(name);
    await user.reload();
    user = auth.currentUser;

    addUserToCollection(user, phoneNumber);
  } on FirebaseAuthException catch (e) {
    if (e.code == WEAK_PASSWORD_ERR) {
      showSnackBar(context, WEAK_PASSWORD_MSG);
    } else if (e.code == EMAIL_IN_USE_ERR) {
      showSnackBar(context, EMAIL_IN_USE_MSG);
    }
  } catch (e) {
    print(e);
    showSnackBar(context, e.toString());
  }

  return user;
}

Future<User?> signInUsingEmailPassword({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == USER_NOT_FOUND_ERR) {
      showSnackBar(context, USER_NOT_FOUND_MSG);
    } else if (e.code == PASSWORD_ERR) {
      showSnackBar(context, PASSWORD_MSG);
    }
  }

  return user;
}

Future<User?> refreshUser(User user) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await user.reload();
  User? refreshedUser = auth.currentUser;

  return refreshedUser;
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

Future<User?> signInWithGoogle({required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        if ((user != null)) {
          addUserToCollection(user, user?.phoneNumber);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ACCOUNT_EXISTS_ERR) {
        showSnackBar(
            context, ACCOUNT_EXISTS_MSG);
        // handle the error here
      } else if (e.code == INVALID_CRED_ERR) {
        showSnackBar(context, INVALID_CRED_MSG);
        // handle the error here
      }
    } catch (e) {
      // handle the error here
      showSnackBar(context, e.toString());
    }
  }

  return user;
}
