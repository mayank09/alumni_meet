import 'package:alumnimeet/firebase/firestore.dart';
import 'package:alumnimeet/ui/homePage.dart';
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
    if (e.code == 'weak-password') {
      showSnackBar(context, 'The password provided is too weak.');
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      showSnackBar(context, 'The account already exists for that email.');
      print('The account already exists for that email.');
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
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      showSnackBar(context, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
      showSnackBar(context, 'Wrong password provided.');
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
      if (e.code == 'account-exists-with-different-credential') {
        showSnackBar(
            context, 'Account already exists with a different credential');
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        showSnackBar(context, 'Invalid credential');
        // handle the error here
      }
    } catch (e) {
      // handle the error here
      showSnackBar(context, e.toString());
    }
  }

  return user;
}
