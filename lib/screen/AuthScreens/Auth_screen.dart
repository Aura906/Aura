// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final _auth = FirebaseAuth.instance;

//   Future<User?> createUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final cred = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return cred.user;
//     } catch (e) {
//       log("Something went wrong");
//     }
//     return null;
//   }

//   Future<User?> loginUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final cred = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return cred.user;
//     } catch (e) {
//       log("Something went wrong");
//     }
//     return null;
//   }

//   Future<void> signout() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       log("Something went wrong");
//     }
//   }
// }

// import 'package:aurasecure/screens/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // showToast(message: 'The email address is already in use.');
      } else {
        // showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // showToast(message: 'Invalid email or password.');
      } else {
        // showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      // showToast(message: "You have been logged out.");
    } catch (e) {
      // showToast(message: "An error occurred during logout: $e");
    }
  }
}
