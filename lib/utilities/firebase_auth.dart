import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<User?> createUserWithEmailAndPassword({
  required String emailAddress,
  required String password,
}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      if (kDebugMode) {
        print('The password provided is too weak.');
      }
    } else if (e.code == 'email-already-in-use') {
      if (kDebugMode) {
        print('The account already exists for that email.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return null;
}

Future<User?> signInWithEmailAndPassword({
  required String emailAddress,
  required String password,
}) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      if (kDebugMode) {
        print('No user found for that email.');
      }
    } else if (e.code == 'wrong-password') {
      if (kDebugMode) {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }
}

Future<User?> getLoginedUser() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return user;
  }

  return null;
}

Future<void> logoutUser() async {
  await FirebaseAuth.instance.signOut();
}

String getLoggedInUserId() {
  return FirebaseAuth.instance.currentUser?.uid ?? "";
}