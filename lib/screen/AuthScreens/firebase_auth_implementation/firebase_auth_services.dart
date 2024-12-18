// // import 'dart:math';

// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';

// class FirebaseAuthService {
//   FirebaseAuth auth = FirebaseAuth.instance;

//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential credential = await auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return credential.user;
//     } catch (e) {
//       print("Some error occured");
//     }
//     return null;
//   }

//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential credential = await auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return credential.user;
//     } catch (e) {
//       print("Some error occured");
//     }
//     return null;
//   }
// }
