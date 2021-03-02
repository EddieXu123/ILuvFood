import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/enum.dart';

/*
This class handles the firebase auth and creating docs of customers/business
in firestore.
*/
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // // sign in anon
  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email & password

  Future signInWithEmailandPassword(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(
    //           email: email,
    //           password: password);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }
    // }
  }

  // Future customerSignInWithEmailandPassword(
  //     String email, String password) async {
  //   try {
  //     // check if email and password combo is valid
  //     AuthResult result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     return _authUserFromFirebaseUser(user);
  //   } catch (e) {
  //     print("hello rip");
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future customerRegisterWithEmailandPassword(
      String email, String password, String name) async {
    // attempt to registe ruser
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // add user document with customer information
    final uid = _auth.currentUser.uid;
    await DatabaseService(uid: uid).enterUserData(name, Role.CUSTOMER);
    // try {
    //   UserCredential userCredential = await _auth
    //       .createUserWithEmailAndPassword(email: email, password: password);
    //   // add user document with customer information
    //   final uid = _auth.currentUser.uid;
    //   await DatabaseService(uid: uid).enterUserData(name, Role.CUSTOMER);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  // // customer register with email and password
  // Future customerRegisterWithEmailandPassword(
  //     String email, String password, String firstName, String lastName) async {
  //   try {
  //     // tell firebase_auth to create new customer creds
  //     AuthResult result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;

  //     // create a new firestore document for the user
  //     await DatabaseService(uid: user.uid)
  //         .updateCustomerUserData(firstName, lastName);
  //     return _authUserFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
